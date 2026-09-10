# Weekly Backups

On Arch Linux or EndeavourOS, run from your normal user session:

```sh
zsh /path/to/configs/setupBackupTimer.sh
```

The installer asks for confirmation (default: no), then writes
`backup-configs.service` and `backup-configs.timer` into
`$XDG_CONFIG_HOME/systemd/user` (normally `~/.config/systemd/user`) and enables
the timer. No sudo is needed. Running the installer again asks for confirmation
and updates the setup. Unchanged units are left untouched; changed units are
replaced atomically. Reinstallation does not restart an active backup or create
duplicate timers. Declining leaves an existing installation unchanged.

Backups run Sunday at 23:00 in the system's local timezone. `Persistent=true`
catches up a missed run when the user manager next starts, usually at login.
The machine must be awake and the user manager running to execute a backup.
The installer does not enable lingering or wake the machine.

The installer uses `configPaths.zsh` next to it, or `CONFIG_PATHS_FILE` if set.
It captures the resolved workdrive, repository, XDG paths, and Git remote/branch
settings so the service does not depend on `.zshrc`. Set those environment
variables before installation when using custom paths. Keep the installer,
backup script, and reference file in a stable location; rerun setup after moving
them or changing settings. The scripts remain in that location, not in systemd's
unit directory. Installation is separate from backup and restore, so neither
silently enables automation on a new machine.

Requirements: `systemd`, `zsh`, `git`, the usual core utilities, a writable backup
repository, and working unattended Git credentials and commit identity. SSH must
already trust the host and have an available key or agent. The service disables
Git terminal prompts and uses SSH batch mode; authentication errors are logged.
It runs the normal backup including Git commit/push. A failed run is not retried
automatically; inspect the journal and start it manually after fixing the cause.
First verify the backup manually with your chosen paths and credentials.

```sh
systemctl --user list-timers backup-configs.timer
systemctl --user start backup-configs.service
journalctl --user -u backup-configs.service
systemctl --user disable --now backup-configs.timer
```

Disabling the timer stops future scheduling. To remove the installation, also
delete its two unit files and run `systemctl --user daemon-reload`.
