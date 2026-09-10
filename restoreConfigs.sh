#!/usr/bin/env zsh
# Restore configs from the backup repo onto the current system.

set -eu
set -o pipefail

# ---- CLI flags ----
DRY_RUN=0
PULL_LATEST=1
NO_SAFETY_BACKUP=0

for arg in "$@"; do
    case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    --no-pull) PULL_LATEST=0 ;;
    --no-safety-backup) NO_SAFETY_BACKUP=1 ;;
    -h|--help)
        echo "Usage: $0 [-n|--dry-run] [--no-pull] [--no-safety-backup]"
        exit 0
        ;;
    *)
        echo "Unknown argument: $arg" 1>&2
        echo "Usage: $0 [-n|--dry-run] [--no-pull] [--no-safety-backup]" 1>&2
        exit 2
        ;;
    esac
done

# ---- Fun output helpers (use lolcat if available) ----
_have_lolcat() { command -v lolcat >/dev/null 2>&1; }
say() {
    if _have_lolcat; then printf "%s\n" "$@" | lolcat; else printf "%s\n" "$@"; fi
}
say_err() {
    if _have_lolcat; then printf "%s\n" "$@" | lolcat 1>&2; else printf "%s\n" "$@" 1>&2; fi
}

# ---- Runner helper (respects dry-run) ----
run_cmd() {
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] $*"
    else
        "$@"
    fi
}

resolve_script_path() {
    local candidate="$1" found

    if [[ "$candidate" != */* ]]; then
        if found="$(command -v -- "$candidate" 2>/dev/null)"; then
            candidate="$found"
        fi
    fi

    if command -v realpath >/dev/null 2>&1; then
        realpath "$candidate" 2>/dev/null || printf "%s\n" "$candidate"
    elif command -v readlink >/dev/null 2>&1; then
        readlink -f "$candidate" 2>/dev/null || printf "%s\n" "$candidate"
    else
        printf "%s\n" "$candidate"
    fi
}

same_path() {
    local left="$1" right="$2" resolved_left resolved_right

    [ -e "$left" ] || [ -L "$left" ] || return 1
    [ -e "$right" ] || [ -L "$right" ] || return 1

    if command -v realpath >/dev/null 2>&1; then
        resolved_left="$(realpath "$left" 2>/dev/null)" || return 1
        resolved_right="$(realpath "$right" 2>/dev/null)" || return 1
        [ "$resolved_left" = "$resolved_right" ]
    else
        [ "$left" = "$right" ]
    fi
}

source_config_paths() {
    local candidate
    local -a candidates

    if [ -n "${CONFIG_PATHS_FILE:-}" ]; then
        candidates=("$CONFIG_PATHS_FILE")
    else
        candidates=(
            "$CONFIG_FOLDER/configPaths.zsh"
            "$SCRIPT_DIR/configPaths.zsh"
            "$PWD/configPaths.zsh"
        )
    fi

    for candidate in "${candidates[@]}"; do
        if [ -f "$candidate" ]; then
            CONFIG_PATHS_FILE="$(resolve_script_path "$candidate")"
            source "$CONFIG_PATHS_FILE"
            return 0
        fi
    done

    say_err "Unable to find configPaths.zsh."
    say_err "Set CONFIG_PATHS_FILE=/path/to/configPaths.zsh or place it in $CONFIG_FOLDER."
    exit 1
}

parse_config_entry() {
    local entry="$1" rest

    ENTRY_KIND="${entry%%|*}"
    rest="${entry#*|}"
    ENTRY_REPO_PATH="${rest%%|*}"
    rest="${rest#*|}"
    ENTRY_TARGET_PATH="${rest%%|*}"
    ENTRY_LABEL="${rest#*|}"
}

parse_pack_entry() {
    local entry="$1" rest

    PACK_REPO_PATH="${entry%%|*}"
    rest="${entry#*|}"
    PACK_SOURCE_PATH="${rest%%|*}"
    PACK_LABEL="${rest#*|}"
}

# ---- Bootstrap defaults used to locate the shared path file ----
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
WORKDRIVE="${WORKDRIVE:-"$HOME"}"
CONFIG_FOLDER="${CONFIG_FOLDER:-"$WORKDRIVE/Backups/configs"}"
SCRIPT_PATH="$(resolve_script_path "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

source_config_paths

RESTORE_TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
RESTORE_BACKUP_ROOT="${RESTORE_BACKUP_ROOT:-"$HOME/.config-restore-backups"}"

[ "$DRY_RUN" -eq 1 ] && say "DRY RUN - no changes will be made."
[ "$NO_SAFETY_BACKUP" -eq 1 ] && say "Safety backups disabled."

if [ ! -d "$CONFIG_FOLDER" ]; then
    say_err "Backup repository not found at $CONFIG_FOLDER"
    exit 1
fi

say "Switching to $CONFIG_FOLDER..."
cd "$CONFIG_FOLDER"

# ---- Pull latest changes ----
if [ "$PULL_LATEST" -eq 1 ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] git pull --rebase origin $REPO_BRANCH (if this is a git repo with that branch)"
    elif command -v git >/dev/null 2>&1 && [ -d ".git" ]; then
        if git ls-remote --exit-code --heads origin "$REPO_BRANCH" >/dev/null 2>&1; then
            say "Pulling latest changes..."
            if ! git pull --rebase origin "$REPO_BRANCH"; then
                say_err "Error pulling latest changes, likely a merge conflict..."
                say_err "Please resolve the conflicts and try again."
                say_err "Aborting..."
                exit 1
            fi
        else
            say "Remote branch $REPO_BRANCH not found; skipping pull."
        fi
    else
        say "Not a git repo, or git is not installed; skipping pull."
    fi
else
    say "Skipping pull."
fi

save_existing_target() {
    local target="$1" label="$2" backup_target

    [ "$NO_SAFETY_BACKUP" -eq 0 ] || return 0
    { [ -e "$target" ] || [ -L "$target" ]; } || return 0

    backup_target="$RESTORE_BACKUP_ROOT/$RESTORE_TIMESTAMP$target"
    say "Saving current $label to $backup_target"
    run_cmd mkdir -p "$(dirname "$backup_target")"
    run_cmd cp -a "$target" "$backup_target"
}

restore_dir() {
    local src="$1" target="$2" label="$3"
    say "Restoring $label..."

    if [ ! -d "$src" ]; then
        say_err "Warning: $label backup not found at $src"
        return 0
    fi

    if [ -e "$target" ] && [ ! -d "$target" ]; then
        say_err "Warning: $label target exists but is not a directory: $target"
        return 0
    fi

    save_existing_target "$target" "$label"
    run_cmd mkdir -p "$target"
    run_cmd cp -a "$src/." "$target/"
}

restore_file_to_path() {
    local src="$1" target="$2" label="$3"
    say "Restoring $label..."

    if [ ! -f "$src" ]; then
        say_err "Warning: $label backup not found at $src"
        return 0
    fi

    if [ -d "$target" ]; then
        say_err "Warning: $label target is a directory, expected a file path: $target"
        return 0
    fi

    if same_path "$src" "$target"; then
        say "$label is already in place at $target"
        return 0
    fi

    save_existing_target "$target" "$label"
    run_cmd mkdir -p "$(dirname "$target")"
    run_cmd cp -a "$src" "$target"
}

restore_entry() {
    local kind="$1" repo_path="$2" target_path="$3" label="$4"
    local repo_abs="$CONFIG_FOLDER/$repo_path"

    case "$kind" in
    dir)  restore_dir "$repo_abs" "$target_path" "$label" ;;
    file) restore_file_to_path "$repo_abs" "$target_path" "$label" ;;
    *)    say_err "Warning: Unknown config entry kind '$kind' for $label" ;;
    esac
}

count_inventory_names() {
    local inventory_file="$1" line count=0

    while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        count=$((count + 1))
    done < "$inventory_file"

    printf "%s\n" "$count"
}

show_pack_inventory() {
    local inventory_file="$1" label="$2" count

    if [ ! -f "$inventory_file" ]; then
        say_err "Warning: $label inventory not found at $inventory_file"
        return 0
    fi

    count="$(count_inventory_names "$inventory_file")"
    say "Inventory for $label is list-only: $count pack names saved in $inventory_file"
    say "Install those packs independently on this system when needed."
}

# ---- Restores ----
for entry in "${CONFIG_PATH_ENTRIES[@]}"; do
    parse_config_entry "$entry"
    restore_entry "$ENTRY_KIND" "$ENTRY_REPO_PATH" "$ENTRY_TARGET_PATH" "$ENTRY_LABEL"
done

for entry in "${PACK_NAME_ENTRIES[@]}"; do
    parse_pack_entry "$entry"
    show_pack_inventory "$CONFIG_FOLDER/$PACK_REPO_PATH" "$PACK_LABEL"
done

restore_file_to_path "$BACKUP_SCRIPT_DEST_FILE" "$BACKUP_SCRIPT_SOURCE" "Backup script"
restore_file_to_path "$CONFIG_PATHS_DEST_FILE" "$CONFIG_PATHS_TARGET" "Config path reference"

if same_path "$RESTORE_SCRIPT_SOURCE" "$SCRIPT_PATH"; then
    say "Restore script is currently running from $RESTORE_SCRIPT_SOURCE; skipping self-update."
else
    restore_file_to_path "$RESTORE_SCRIPT_DEST_FILE" "$RESTORE_SCRIPT_SOURCE" "Restore script"
fi

say "Restore completed successfully!"
