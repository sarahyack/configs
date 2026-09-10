#!/usr/bin/env zsh

set -eu
set -o pipefail

fail() {
    print -u2 -- "FAIL: $*"
    exit 1
}

assert_file_contains() {
    local file="$1" expected="$2"

    [ -f "$file" ] || fail "Expected file to exist: $file"
    grep -Fqx -- "$expected" "$file" || fail "Expected '$expected' in $file"
}

assert_file_text() {
    local file="$1" expected="$2" actual

    [ -f "$file" ] || fail "Expected file to exist: $file"
    actual="$(<"$file")"
    [ "$actual" = "$expected" ] || fail "Expected $file to contain '$expected', got '$actual'"
}

assert_path_missing() {
    local path="$1"

    [ ! -e "$path" ] || fail "Expected path to be absent: $path"
}

inventory_names() {
    local file="$1"

    grep -vE '^[[:space:]]*(#|$)' "$file"
}

assert_inventory_names() {
    local file="$1"
    local expected="$2"
    local actual

    [ -f "$file" ] || fail "Expected inventory to exist: $file"
    actual="$(inventory_names "$file")"
    [ "$actual" = "$expected" ] || fail "Unexpected inventory contents in $file: $actual"
}

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/configs-flow-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT

export HOME="$TEST_ROOT/home"
export WORKDRIVE="$TEST_ROOT/workdrive"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export CONFIG_FOLDER="$TEST_ROOT/config-repo"
export CONFIG_PATHS_FILE="$PROJECT_ROOT/configPaths.zsh"
export RESTORE_BACKUP_ROOT="$TEST_ROOT/restore-safety"
export BACKUP_SCRIPT_SOURCE="$PROJECT_ROOT/backupConfigs.sh"
export RESTORE_SCRIPT_SOURCE="$PROJECT_ROOT/restoreConfigs.sh"

mkdir -p \
    "$XDG_CONFIG_HOME/nvim" \
    "$WORKDRIVE/Documents/Vaults/Beehive/.obsidian" \
    "$XDG_CONFIG_HOME/fastfetch" \
    "$XDG_CONFIG_HOME/kitty" \
    "$XDG_DATA_HOME/fooyin" \
    "$HOME/.themes/Theme B" \
    "$HOME/.themes/Theme A" \
    "$XDG_DATA_HOME/icons/Icon Two" \
    "$XDG_DATA_HOME/icons/Icon One" \
    "$HOME/.icons/Cursor Z" \
    "$HOME/.icons/Cursor A"

printf "nvim-backup\n" > "$XDG_CONFIG_HOME/nvim/init.lua"
printf "obsidian-backup\n" > "$WORKDRIVE/Documents/Vaults/Beehive/.obsidian/app.json"
printf "fastfetch-backup\n" > "$XDG_CONFIG_HOME/fastfetch/config.jsonc"
printf "kitty-backup\n" > "$XDG_CONFIG_HOME/kitty/kitty.conf"
printf "zsh-backup\n" > "$HOME/.zshrc"
printf "tmux-backup\n" > "$HOME/.tmux.conf"
printf "fooyin-backup\n" > "$XDG_DATA_HOME/fooyin/fooyin.db"

zsh "$PROJECT_ROOT/backupConfigs.sh" --no-git-sync >/dev/null

assert_file_text "$CONFIG_FOLDER/nvim/init.lua" "nvim-backup"
assert_file_text "$CONFIG_FOLDER/obsidian/app.json" "obsidian-backup"
assert_file_text "$CONFIG_FOLDER/fastfetch/config.jsonc" "fastfetch-backup"
assert_file_text "$CONFIG_FOLDER/kitty/kitty.conf" "kitty-backup"
assert_file_text "$CONFIG_FOLDER/zsh/.zshrc" "zsh-backup"
assert_file_text "$CONFIG_FOLDER/tmux/.tmux.conf" "tmux-backup"
assert_file_text "$CONFIG_FOLDER/fooyin/fooyin.db" "fooyin-backup"

assert_path_missing "$CONFIG_FOLDER/gtk_themes"
assert_path_missing "$CONFIG_FOLDER/gtk_icons"
assert_path_missing "$CONFIG_FOLDER/gtk_cursors"

assert_inventory_names "$CONFIG_FOLDER/gtk_packs/themes.txt" $'Theme A\nTheme B'
assert_inventory_names "$CONFIG_FOLDER/gtk_packs/icons.txt" $'Icon One\nIcon Two'
assert_inventory_names "$CONFIG_FOLDER/gtk_packs/cursors.txt" $'Cursor A\nCursor Z'

printf "nvim-live-change\n" > "$XDG_CONFIG_HOME/nvim/init.lua"
printf "zsh-live-change\n" > "$HOME/.zshrc"
printf "kitty-live-change\n" > "$XDG_CONFIG_HOME/kitty/kitty.conf"

unset CONFIG_PATHS_FILE
zsh "$PROJECT_ROOT/restoreConfigs.sh" --no-pull >/dev/null

assert_file_text "$XDG_CONFIG_HOME/nvim/init.lua" "nvim-backup"
assert_file_text "$HOME/.zshrc" "zsh-backup"
assert_file_text "$XDG_CONFIG_HOME/kitty/kitty.conf" "kitty-backup"
assert_file_contains "$HOME/Documents/sh-scripts/configPaths.zsh" 'CONFIG_PATH_ENTRIES=('

safety_backup="$(find "$RESTORE_BACKUP_ROOT" -type f -path "*/home/.zshrc" -print -quit)"
[ -n "$safety_backup" ] || fail "Expected restore safety backup for .zshrc"

assert_path_missing "$HOME/.themes/Theme Installed By Restore"

print -- "backup_restore_flow: ok"
