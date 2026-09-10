#!/usr/bin/env zsh
# Install a per-user weekly backup timer after explicit confirmation.
set -eu
set -o pipefail

case "${1:-}" in
    -h|--help)
        print -- "Usage: zsh $0"
        print -- "Offers to install a user timer for Sunday at 23:00 local time."
        exit 0 ;;
    '') ;;
    *) print -u2 -- "Unknown argument: $1"; exit 2 ;;
esac
(( $# <= 1 )) || { print -u2 -- 'Too many arguments'; exit 2; }

SCRIPT_DIR="${0:A:h}"
CONFIG_PATHS_FILE="${CONFIG_PATHS_FILE:-$SCRIPT_DIR/configPaths.zsh}"
CONFIG_PATHS_FILE="${CONFIG_PATHS_FILE:A}"
[[ -f "$CONFIG_PATHS_FILE" ]] || { print -u2 -- "Missing $CONFIG_PATHS_FILE"; exit 1; }
source "$CONFIG_PATHS_FILE"

print -- 'Install weekly configuration backups for this user?'
print -- "Repository: $CONFIG_FOLDER"
print -- 'Schedule: Sunday 23:00 local time, with missed runs caught up at login.'
print -- 'This enables Git commit/push; existing noninteractive credentials are required.'
print -n -- 'Install and enable the timer? [y/N] '
answer=''
if ! read -r answer || [[ "$answer" != [yY] && "$answer" != [yY][eE][sS] ]]; then
    print -- 'Timer installation skipped.'
    exit 0
fi

for dependency in systemctl zsh git; do
    command -v "$dependency" >/dev/null || { print -u2 -- "Missing dependency: $dependency"; exit 1; }
done
# Check the user manager before writing any files.
systemctl --user show-environment >/dev/null
[[ -f "$SCRIPT_DIR/backupConfigs.sh" ]] || { print -u2 -- 'Missing backupConfigs.sh next to installer'; exit 1; }

# Unit values use systemd quoting, not shell quoting. Escape specifiers too.
unit_quote() {
    local value="$1"
    [[ "$value" != *$'\n'* && "$value" != *$'\r'* ]] || {
        print -u2 -- 'Paths and settings must not contain newlines.'; return 1
    }
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//\%/%%}"
    print -rn -- "\"$value\""
}

service="$(
    print -- '[Unit]'
    print -- 'Description=Back up user configuration files to Git'
    print -l -- '' '[Service]' 'Type=oneshot' 'UMask=0077'
    print -l -- 'TimeoutStartSec=30min' 'StandardInput=null'
    print -- 'Environment=GIT_TERMINAL_PROMPT=0'
    print -- 'Environment="GIT_SSH_COMMAND=ssh -o BatchMode=yes -o ConnectTimeout=30"'
    for setting in XDG_CONFIG_HOME XDG_DATA_HOME WORKDRIVE CONFIG_FOLDER CONFIG_PATHS_FILE REPO_URL REPO_BRANCH; do
        print -r -- "Environment=$(unit_quote "$setting=${(P)setting}")"
    done
    # Use the selected copy for both execution and the backup's self-copy.
    print -r -- "Environment=$(unit_quote "BACKUP_SCRIPT_SOURCE=$SCRIPT_DIR/backupConfigs.sh")"
    print -r -- "Environment=$(unit_quote "RESTORE_SCRIPT_SOURCE=$SCRIPT_DIR/restoreConfigs.sh")"
    executable="$(unit_quote "$(command -v zsh)")"
    script="$(unit_quote "$SCRIPT_DIR/backupConfigs.sh")"
    print -r -- "ExecStart=${executable//\$/\$\$} ${script//\$/\$\$}"
)"

unit_dir="$XDG_CONFIG_HOME/systemd/user"
mkdir -p -- "$unit_dir"
# Stage replacements on the same filesystem so readers never see partial units.
staging_dir="$(mktemp -d "$unit_dir/.backup-configs.XXXXXX")"
trap 'rm -rf -- "$staging_dir"' EXIT
print -r -- "$service" > "$staging_dir/backup-configs.service"
print -r -- '[Unit]
Description=Weekly configuration backup

[Timer]
OnCalendar=Sun *-*-* 23:00:00
Persistent=true
Unit=backup-configs.service

[Install]
WantedBy=timers.target' > "$staging_dir/backup-configs.timer"

for unit in backup-configs.service backup-configs.timer; do
    if ! cmp -s -- "$staging_dir/$unit" "$unit_dir/$unit"; then
        chmod 644 "$staging_dir/$unit"
        mv -f -- "$staging_dir/$unit" "$unit_dir/$unit"
    fi
done

systemctl --user daemon-reload
systemctl --user enable --now backup-configs.timer
print -- 'Weekly backup timer enabled.'
print -- 'Check schedule: systemctl --user list-timers backup-configs.timer'
print -- 'Read logs: journalctl --user -u backup-configs.service'
