# ez-linux-scripts

A collection of personal utility and automation scripts for openSUSE and Linux environments, optimized for quick terminal use and desktop integration.

No cloning required — everything installs and updates straight from the remote repository.

## Install

Run the online installer (downloads the latest repository, installs everything, then cleans up):

```bash
curl -fsSL https://raw.githubusercontent.com/cptodix/ez-linux-scripts/main/install | bash
```

What it does:
- Downloads the latest repository as an archive (into a temporary directory)
- Installs all scripts to `~/.local/bin` and makes them executable
- Generates `.desktop` shortcuts in `~/.local/share/applications/`
- Adds `alias goto='. goto'` to `~/.bashrc` (used by the `goto` bookmark manager) — skipped if already present
- Installs `update-scripts` for future updates
- Asks whether to run `install-win-fonts` (default: no)
- Removes all temporary files when done

> Tip: You can keep a local copy of `install` for offline use (`./install`), or just re-run the curl command anytime.

## Update

Keep every installed script up to date from the remote repository (only changed files are overwritten):

```bash
update-scripts
```

This fetches the latest repository as an archive into a temporary directory, syncs your installed scripts, and deletes the temporary files when done.

## Uninstall

Remove all installed scripts and their `.desktop` shortcuts:

```bash
curl -fsSL https://raw.githubusercontent.com/cptodix/ez-linux-scripts/main/install | bash -s -- --uninstall
```

Or, if you have a local copy:

```bash
./install --uninstall
```

## Usage

All scripts are installed as terminal commands in `~/.local/bin`:

| Command | Description |
| ------- | ----------- |
| [`ez-install`](scripts/ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.) that extracts to `~/.local/share`, links binaries to `~/.local/bin`, finds icons, and interactive category selection for `.desktop` shortcuts. |
| [`proton-reset`](scripts/proton-reset) | Steam Proton troubleshooting utility that scans all storage libraries, lists installed games, backs up common savegame folders, deletes `compatdata` to reset Proton, and supports backup restore (`--restore`). |
| [`pkg-update`](scripts/pkg-update) | Package updater (Zypper ref/dup + Flatpak update/cleanup) with an explicit exit prompt. |
| [`install-win-fonts`](scripts/install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites (`ms-fonts`). Executed manually after install. |
| [`goto`](scripts/goto) | Interactive directory bookmark manager — save, select, and jump to frequently used directories with numeric shortcuts. |
| [`sddm-guest`](scripts/sddm-guest) | Manages SDDM login manager guest account visibility (`hide`, `unhide`, `toggle`, `status`). Automatically creates the `guest` user if missing when unhiding. |
| [`agy-auth`](scripts/agy-auth) | Utility for switching `antigravity-cli` between API Key and Google OAuth authentication modes. |

## Repository Structure

```
ez-linux-scripts/
├── install           # Online installer/uninstaller (downloads repo to temp, installs, cleans up)
├── update-scripts    # Online updater (downloads repo to temp, syncs, cleans up)
├── README.md
├── AGENTS.md
├── LICENSE
└── scripts/          # All script files live directly in scripts/
    ├── agy-auth
    ├── ez-install
    ├── goto
    ├── install-win-fonts
    ├── pkg-update
    ├── proton-reset
    └── sddm-guest
```

Each script is a single flat file for simplicity.

## Adding a New Script

1. Create a new file under `scripts/` using kebab-case naming: `scripts/my-new-script`
2. Add a shebang line: `#!/usr/bin/env bash`
3. Commit and push to the remote repository
4. Run `update-scripts` (or `./install` on a fresh system) to deploy it

The installer/updater automatically picks up any new script in `scripts/` — no configuration changes needed.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
