#!/usr/bin/env zsh
# Shared path inventory for backupConfigs.sh and restoreConfigs.sh.

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
WORKDRIVE="${WORKDRIVE:-"$HOME"}"
CONFIG_FOLDER="${CONFIG_FOLDER:-"$WORKDRIVE/Backups/configs"}"

REPO_URL="${REPO_URL:-"git@github.com:sarahyack/configs.git"}"
REPO_BRANCH="${REPO_BRANCH:-"master"}"

BACKUP_SCRIPT_SOURCE="${BACKUP_SCRIPT_SOURCE:-"$HOME/Documents/sh-scripts/backupConfigs.sh"}"
BACKUP_SCRIPT_DEST_FILE="${BACKUP_SCRIPT_DEST_FILE:-"$CONFIG_FOLDER/backupConfigs.sh"}"

RESTORE_SCRIPT_SOURCE="${RESTORE_SCRIPT_SOURCE:-"$HOME/Documents/sh-scripts/restoreConfigs.sh"}"
RESTORE_SCRIPT_DEST_FILE="${RESTORE_SCRIPT_DEST_FILE:-"$CONFIG_FOLDER/restoreConfigs.sh"}"

CONFIG_PATHS_TARGET="${CONFIG_PATHS_TARGET:-"$HOME/Documents/sh-scripts/configPaths.zsh"}"
CONFIG_PATHS_DEST_FILE="${CONFIG_PATHS_DEST_FILE:-"$CONFIG_FOLDER/configPaths.zsh"}"

CONFIG_PATH_ENTRIES=(
    "dir|nvim|$XDG_CONFIG_HOME/nvim|Neovim config"
    "dir|obsidian|$WORKDRIVE/Documents/Vaults/Beehive/.obsidian|Obsidian config"
    "dir|fastfetch|$XDG_CONFIG_HOME/fastfetch|Fastfetch config"
    "dir|kitty|$XDG_CONFIG_HOME/kitty|Kitty config"
    "file|zsh/.zshrc|$HOME/.zshrc|Zsh config"
    "file|tmux/.tmux.conf|$HOME/.tmux.conf|Tmux config"
    "dir|fooyin|$XDG_DATA_HOME/fooyin|Fooyin database"
)

PACK_NAME_ENTRIES=(
    "gtk_packs/themes.txt|$HOME/.themes|GTK themes"
    "gtk_packs/icons.txt|$XDG_DATA_HOME/icons|GTK icon packs"
    "gtk_packs/cursors.txt|$HOME/.icons|GTK cursor packs"
)
