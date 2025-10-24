#!/usr/bin/env zsh
# Backup configs into a git repo
# Linux/XDG-aware rewrite with lolcat output

set -eu
set -o pipefail

# ---- CLI flags ----
DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help)
        echo "Usage: $0 [-n|--dry-run]"
        exit 0
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

# ---- Paths (edit as needed) ----
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
WORKDRIVE="${WORKDRIVE:-"$HOME"}"
CONFIG_FOLDER="$WORKDRIVE/Backups/configs"

NEOVIM_CONFIG_SOURCE="$XDG_CONFIG_HOME/nvim"
NEOVIM_AUTOLOAD_SOURCE="$XDG_CONFIG_HOME/nvim/autoload"
NEOVIM_CONFIG_DEST="$CONFIG_FOLDER/neovim"

OBSIDIAN_CONFIG_SOURCE="$WORKDRIVE/Documents/Vaults/Beehive/.obsidian"
OBSIDIAN_CONFIG_DEST="$CONFIG_FOLDER/obsidian"

FASTFETCH_CONFIG_SOURCE="$XDG_CONFIG_HOME/fastfetch"
FASTFETCH_CONFIG_DEST="$CONFIG_FOLDER/fastfetch"

KITTY_CONFIG_SOURCE="$XDG_CONFIG_HOME/kitty"
KITTY_CONFIG_DEST="$CONFIG_FOLDER/kitty"

ZSH_CONFIG_SOURCE="$HOME/.zshrc"
ZSH_CONFIG_DEST="$CONFIG_FOLDER/zsh"

TMUX_CONFIG_SOURCE="$HOME/.tmux.conf"
TMUX_CONFIG_DEST="$CONFIG_FOLDER/tmux"

GTK_THEMES_CONFIG_SOURCE="$HOME/.themes"
GTK_THEMES_CONFIG_DEST="$CONFIG_FOLDER/gtk_themes"

GTK_ICONS_CONFIG_SOURCE="$XDG_DATA_HOME/icons"
GTK_ICONS_CONFIG_DEST="$CONFIG_FOLDER/gtk_icons"

GTK_CURSORS_CONFIG_SOURCE="$HOME/.icons"
CTK_CURSORS_CONFIG_DEST="$CONFIG_FOLDER/gtk_cursors"

# Source path for this script (preferred fixed path, with self fallback)
BACKUP_SCRIPT_SOURCE="$HOME/Documents/sh-scripts/backupConfigs.sh"
if [ ! -f "$BACKUP_SCRIPT_SOURCE" ]; then
    # fallback to the currently-running script path
    SELF_PATH="$0"
    if command -v realpath >/dev/null 2>&1; then
        SELF_PATH="$(realpath "$SELF_PATH")"
    elif command -v readlink >/dev/null 2>&1; then
        SELF_PATH="$(readlink -f "$SELF_PATH" 2>/dev/null || echo "$SELF_PATH")"
    fi
    BACKUP_SCRIPT_SOURCE="$SELF_PATH"
    say "Note: Using current script as source: $BACKUP_SCRIPT_SOURCE"
fi
BACKUP_SCRIPT_DEST_FILE="$CONFIG_FOLDER/backupConfigs.sh"

REPO_URL="git@github.com:sarahyack/configs.git"    # change if needed
REPO_BRANCH="master"                               # use "main" if your repo uses main

[ "$DRY_RUN" -eq 1 ] && say "DRY RUN — no changes will be made."

# ---- Require git ----
say "Checking for Git..."
if ! command -v git >/dev/null 2>&1; then
    say_err "Git is not installed. Please install Git and try again."
    exit 1
fi

# ---- Ensure destination dirs ----
say "Ensuring destination directories exist..."
run_cmd mkdir -p \
    "$CONFIG_FOLDER" \
    "$NEOVIM_CONFIG_DEST" "$OBSIDIAN_CONFIG_DEST" \
    "$FASTFETCH_CONFIG_DEST" "$KITTY_CONFIG_DEST" \
    "$ZSH_CONFIG_DEST" "$TMUX_CONFIG_DEST" \
    "$GTK_THEMES_CONFIG_DEST" "$GTK_ICONS_CONFIG_DEST" \
    "$GTK_CURSORS_CONFIG_DEST"

# ---- Enter configs folder ----
say "Switching to $CONFIG_FOLDER..."
cd "$CONFIG_FOLDER"

# ---- Ensure it's a Git repo ----
if [ ! -d ".git" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] git init"
    else
        say "Initializing Git repository..."
        git init
    fi
    # Ensure .gitattributes has a sane default
    if ! { [ -f .gitattributes ] && grep -q '^\* text=auto' .gitattributes; }; then
        if [ "$DRY_RUN" -eq 1 ]; then
            say "[DRY-RUN] printf '* text=auto\\n' >> .gitattributes"
        else
            printf "* text=auto\n" >> .gitattributes
        fi
    fi
    # Add origin if missing
    if ! git remote get-url origin >/dev/null 2>&1; then
        run_cmd git remote add origin "$REPO_URL"
    fi
fi

# ---- Pull latest changes ----
if git ls-remote --exit-code --heads origin "$REPO_BRANCH" >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
        say "[DRY-RUN] git pull --rebase origin $REPO_BRANCH"
    else
        say "Pulling latest changes..."
        if ! git pull --rebase origin "$REPO_BRANCH"; then
          say_err "Error pulling latest changes, likely a merge conflict..."
          say_err "Please resolve the conflicts and try again."
          say_err "Aborting..."
          exit 1
        fi
    fi
else
    say "Remote branch $REPO_BRANCH not found; skipping pull. first time?"
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

backup_file() {
    local src="$1" dest_dir="$2" label="$3"
    say "Copying $label..."
    if [ -f "$src" ]; then
        run_cmd mkdir -p "$dest_dir"
        run_cmd cp -a "$src" "$dest_dir/"
    else
        say_err "Warning: $label not found at $src"
    fi
}

backup_file_to_path() {
    local src="$1" dest_file="$2" label="$3"
    say "Copying $label..."
    if [ -f "$src" ]; then
        run_cmd mkdir -p "$(dirname "$dest_file")"
        run_cmd cp -a "$src" "$dest_file"
    else
        say_err "Warning: $label not found at $src"
    fi
}

# ---- Backups ----
backup_dir  "$NEOVIM_CONFIG_SOURCE"      "$NEOVIM_CONFIG_DEST"     "Neovim config"
backup_dir  "$OBSIDIAN_CONFIG_SOURCE"    "$OBSIDIAN_CONFIG_DEST"        "Obsidian config"
backup_dir  "$FASTFETCH_CONFIG_SOURCE"   "$FASTFETCH_CONFIG_DEST"       "Fastfetch config"
backup_dir  "$KITTY_CONFIG_SOURCE"       "$KITTY_CONFIG_DEST"           "Kitty config"
backup_file "$ZSH_CONFIG_SOURCE"         "$ZSH_CONFIG_DEST"             "Zsh config"
backup_file "$TMUX_CONFIG_SOURCE"        "$TMUX_CONFIG_DEST"            "Tmux config"
backup_dir  "$GTK_THEMES_CONFIG_SOURCE"  "$GTK_THEMES_CONFIG_DEST"      "GTK themes"
backup_dir  "$GTK_ICONS_CONFIG_SOURCE"   "$GTK_ICONS_CONFIG_DEST"       "GTK icons"
backup_dir  "$GTK_CURSORS_CONFIG_SOURCE" "$GTK_CURSORS_CONFIG_DEST"     "GTK cursors"

backup_file_to_path "$BACKUP_SCRIPT_SOURCE" "$BACKUP_SCRIPT_DEST_FILE"   "Backup script"

# ---- Git add/commit/push ----
if [ "$DRY_RUN" -eq 1 ]; then
    say "[DRY-RUN] git add ."
    say "[DRY-RUN] git commit -m 'Automated Backup $(date '+%Y-%m-%d %H:%M:%S')'"
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
