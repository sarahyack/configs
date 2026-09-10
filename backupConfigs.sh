#!/usr/bin/env zsh
# Backup configs into a git repo.
# Linux/XDG-aware with optional lolcat output.

set -eu
set -o pipefail

# ---- CLI flags ----
DRY_RUN=0
NO_GIT_SYNC=0
for arg in "$@"; do
    case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    --no-git-sync) NO_GIT_SYNC=1 ;;
    -h|--help)
        echo "Usage: $0 [-n|--dry-run] [--no-git-sync]"
        exit 0
        ;;
    *)
        echo "Unknown argument: $arg" 1>&2
        echo "Usage: $0 [-n|--dry-run] [--no-git-sync]" 1>&2
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
            "$SCRIPT_DIR/configPaths.zsh"
            "$CONFIG_FOLDER/configPaths.zsh"
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
    say_err "Set CONFIG_PATHS_FILE=/path/to/configPaths.zsh or place it next to this script."
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

if [ ! -f "$BACKUP_SCRIPT_SOURCE" ]; then
    BACKUP_SCRIPT_SOURCE="$SCRIPT_PATH"
    say "Note: Using current script as source: $BACKUP_SCRIPT_SOURCE"
fi

[ "$DRY_RUN" -eq 1 ] && say "DRY RUN - no changes will be made."

# ---- Require git ----
if [ "$NO_GIT_SYNC" -eq 0 ]; then
    say "Checking for Git..."
    if ! command -v git >/dev/null 2>&1; then
        say_err "Git is not installed. Please install Git and try again."
        exit 1
    fi
else
    say "Skipping git sync."
fi

# ---- Ensure destination repo exists ----
say "Ensuring destination repository path exists..."
run_cmd mkdir -p "$CONFIG_FOLDER"

say "Switching to $CONFIG_FOLDER..."
cd "$CONFIG_FOLDER"

# ---- Ensure it's a Git repo ----
if [ "$NO_GIT_SYNC" -eq 0 ] && [ ! -d ".git" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] git init"
    else
        say "Initializing Git repository..."
        git init
    fi

    if ! { [ -f .gitattributes ] && grep -q '^\* text=auto' .gitattributes; }; then
        if [ "$DRY_RUN" -eq 1 ]; then
            say "[DRY-RUN] printf '* text=auto\\n' >> .gitattributes"
        else
            printf "* text=auto\n" >> .gitattributes
        fi
    fi

    if ! git remote get-url origin >/dev/null 2>&1; then
        run_cmd git remote add origin "$REPO_URL"
    fi
fi

# ---- Pull latest changes ----
if [ "$NO_GIT_SYNC" -eq 1 ]; then
    say "Skipping pull."
elif [ "$DRY_RUN" -eq 1 ]; then
    say "[DRY-RUN] git pull --rebase origin $REPO_BRANCH (if the remote branch exists)"
elif git ls-remote --exit-code --heads origin "$REPO_BRANCH" >/dev/null 2>&1; then
    say "Pulling latest changes..."
    if ! git pull --rebase origin "$REPO_BRANCH"; then
        say_err "Error pulling latest changes, likely a merge conflict..."
        say_err "Please resolve the conflicts and try again."
        say_err "Aborting..."
        exit 1
    fi
else
    say "Remote branch $REPO_BRANCH not found; skipping pull. First time?"
fi

backup_dir() {
    local src="$1" dest="$2" label="$3"
    say "Copying $label..."

    if [ -d "$src" ]; then
        run_cmd mkdir -p "$dest"
        run_cmd cp -a "$src/." "$dest/"
    else
        say_err "Warning: $label not found at $src"
    fi
}

backup_file_to_path() {
    local src="$1" dest_file="$2" label="$3"
    say "Copying $label..."

    if [ -f "$src" ]; then
        if same_path "$src" "$dest_file"; then
            say "$label is already in place at $dest_file"
            return 0
        fi

        run_cmd mkdir -p "$(dirname "$dest_file")"
        run_cmd cp -a "$src" "$dest_file"
    else
        say_err "Warning: $label not found at $src"
    fi
}

backup_entry() {
    local kind="$1" repo_path="$2" target_path="$3" label="$4"
    local repo_abs="$CONFIG_FOLDER/$repo_path"

    case "$kind" in
    dir)  backup_dir "$target_path" "$repo_abs" "$label" ;;
    file) backup_file_to_path "$target_path" "$repo_abs" "$label" ;;
    *)    say_err "Warning: Unknown config entry kind '$kind' for $label" ;;
    esac
}

backup_pack_inventory() {
    local src="$1" dest_file="$2" label="$3"
    say "Recording $label inventory..."

    if [ ! -d "$src" ]; then
        say_err "Warning: $label source not found at $src"
        return 0
    fi

    run_cmd mkdir -p "$(dirname "$dest_file")"
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] write sorted top-level pack names from $src to $dest_file"
        return 0
    fi

    {
        printf "# %s\n" "$label"
        printf "# Source: %s\n" "$src"
        printf "# Generated: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
        printf "# Install these independently on a new system; restoreConfigs.sh does not copy pack assets.\n"
        printf "\n"
        find "$src" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -printf "%f\n" | sort
    } > "$dest_file"
}

# ---- Backups ----
for entry in "${CONFIG_PATH_ENTRIES[@]}"; do
    parse_config_entry "$entry"
    backup_entry "$ENTRY_KIND" "$ENTRY_REPO_PATH" "$ENTRY_TARGET_PATH" "$ENTRY_LABEL"
done

for entry in "${PACK_NAME_ENTRIES[@]}"; do
    parse_pack_entry "$entry"
    backup_pack_inventory "$PACK_SOURCE_PATH" "$CONFIG_FOLDER/$PACK_REPO_PATH" "$PACK_LABEL"
done

backup_file_to_path "$BACKUP_SCRIPT_SOURCE" "$BACKUP_SCRIPT_DEST_FILE" "Backup script"
backup_file_to_path "$CONFIG_PATHS_FILE" "$CONFIG_PATHS_DEST_FILE" "Config path reference"

if [ -f "$RESTORE_SCRIPT_SOURCE" ]; then
    backup_file_to_path "$RESTORE_SCRIPT_SOURCE" "$RESTORE_SCRIPT_DEST_FILE" "Restore script"
elif [ -f "$RESTORE_SCRIPT_DEST_FILE" ]; then
    say "Restore script not found at $RESTORE_SCRIPT_SOURCE; keeping repository copy."
else
    say_err "Warning: Restore script not found at $RESTORE_SCRIPT_SOURCE"
fi

# ---- Git add/commit/push ----
if [ "$NO_GIT_SYNC" -eq 1 ]; then
    say "Skipping git commit/push."
elif [ "$DRY_RUN" -eq 1 ]; then
    say "[DRY-RUN] git add ."
    say "[DRY-RUN] git commit -m 'Automated backup $(date '+%Y-%m-%d %H:%M:%S')'"
    say "[DRY-RUN] git push origin $REPO_BRANCH"
else
    say "Committing changes..."
    if [ -z "$(git status --porcelain)" ]; then
        say "No changes detected, skipping commit."
    else
        git add .
        git commit -m "Automated backup $(date '+%Y-%m-%d %H:%M:%S')"
        say "Pushing changes..."
        git push origin "$REPO_BRANCH"
    fi
fi

say "Backup completed successfully!"
