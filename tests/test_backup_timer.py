"""Exercise timer setup without touching the real user manager or running backups."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]


class BackupTimerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="backup-timer-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.scripts = self.root / 'scripts with spaces % and $'
        self.scripts.mkdir()
        for name in ("setupBackupTimer.sh", "configPaths.zsh", "backupConfigs.sh"):
            shutil.copy2(PROJECT / name, self.scripts / name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        mock = self.bin / "systemctl"
        shutil.copy2(PROJECT / "tests/fixtures/systemctl", mock)
        mock.chmod(0o755)
        self.log = self.root / "systemctl.log"
        self.config = self.root / "config"
        self.units = self.config / "systemd/user"
        self.env = dict(os.environ)
        self.env.update(
            PATH=f"{self.bin}:{os.environ['PATH']}",
            SYSTEMCTL_TEST_LOG=str(self.log),
            SYSTEMCTL_TEST_UNAVAILABLE="0",
            CONFIG_PATHS_FILE=str(self.scripts / "configPaths.zsh"),
            XDG_CONFIG_HOME=str(self.config),
            XDG_DATA_HOME=str(self.root / "data"),
            WORKDRIVE=str(self.root / "work drive"),
            CONFIG_FOLDER=str(self.root / 'repo % $ "quoted"'),
        )

    def setup_timer(self, answer, *args):
        return subprocess.run(
            ["zsh", str(self.scripts / "setupBackupTimer.sh"), *args],
            input=answer, text=True, capture_output=True, env=self.env,
        )

    def test_decline_and_eof_have_no_side_effects(self):
        for answer in ("n\n", "\n", "", "maybe\n"):
            with self.subTest(answer=answer):
                result = self.setup_timer(answer)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertFalse(self.units.exists())
                self.assertFalse(self.log.exists())

    def test_confirmation_installs_and_enables_timer(self):
        result = self.setup_timer("yes\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        service = (self.units / "backup-configs.service").read_text()
        timer = (self.units / "backup-configs.timer").read_text()
        self.assertIn("OnCalendar=Sun *-*-* 23:00:00", timer)
        self.assertIn("Persistent=true", timer)
        self.assertIn("WantedBy=timers.target", timer)
        self.assertIn("Type=oneshot", service)
        self.assertIn("GIT_TERMINAL_PROMPT=0", service)
        self.assertIn("BatchMode=yes", service)
        self.assertIn('repo %% $ \\"quoted\\"', service)
        self.assertIn('scripts with spaces %% and $$', service)
        self.assertEqual(self.log.read_text().splitlines(), [
            "--user show-environment", "--user daemon-reload",
            "--user enable --now backup-configs.timer",
        ])
        # Reinstalling is deterministic and does not accumulate unit entries.
        original_stats = {
            name: (self.units / name).stat().st_mtime_ns
            for name in ("backup-configs.service", "backup-configs.timer")
        }
        result = self.setup_timer("Y\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.units / "backup-configs.service").read_text(), service)
        for name, mtime in original_stats.items():
            self.assertEqual((self.units / name).stat().st_mtime_ns, mtime)
        self.assertFalse(list(self.units.glob(".backup-configs.*")))
        if shutil.which("systemd-analyze"):
            checked = subprocess.run(
                ["systemd-analyze", "--user", "verify",
                 str(self.units / "backup-configs.service"),
                 str(self.units / "backup-configs.timer")],
                capture_output=True, text=True,
            )
            self.assertEqual(checked.returncode, 0, checked.stderr)

    def test_declining_reinstall_preserves_existing_units(self):
        self.assertEqual(self.setup_timer("y\n").returncode, 0)
        before = {p.name: p.read_bytes() for p in self.units.iterdir()}
        calls = self.log.read_text()
        self.env["WORKDRIVE"] = str(self.root / "different drive")
        self.assertEqual(self.setup_timer("n\n").returncode, 0)
        self.assertEqual({p.name: p.read_bytes() for p in self.units.iterdir()}, before)
        self.assertEqual(self.log.read_text(), calls)

    def test_confirmed_reinstall_updates_settings(self):
        self.assertEqual(self.setup_timer("y\n").returncode, 0)
        self.env["WORKDRIVE"] = str(self.root / "different drive")
        result = self.setup_timer("y\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        service = (self.units / "backup-configs.service").read_text()
        self.assertIn(f'Environment="WORKDRIVE={self.env["WORKDRIVE"]}"', service)
        self.assertEqual(service.count("ExecStart="), 1)
        self.assertNotIn("restart", self.log.read_text())
        self.assertFalse(list(self.units.glob(".backup-configs.*")))

    def test_unavailable_manager_fails_before_writing(self):
        self.env["SYSTEMCTL_TEST_UNAVAILABLE"] = "1"
        result = self.setup_timer("y\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.units.exists())
        self.assertEqual(self.log.read_text().splitlines(), ["--user show-environment"])

    def test_help_does_not_install(self):
        result = self.setup_timer("", "--help")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.units.exists())
        self.assertFalse(self.log.exists())


if __name__ == "__main__":
    unittest.main()
