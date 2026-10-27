# OpenSUSE Scripts

A collection of personal utility and automation scripts for openSUSE and Linux environments, optimized for quick terminal use.

## Repository Structure

```
opensuse_scripts/
├── install-scripts          # Entry point — scans scripts/*
├── update-scripts           # Mirror of scripts/* — scans recursively
├── README.md
├── AGENTS.md
├── LICENSE
└── scripts/                 # All script files live directly in scripts/
    ├── agy-auth
    ├── ez-install
    ├── goto
    ├── install-win-fonts
    ├── pkg-update
    ├── proton-reset
    └── sddm-guest
```

Each script is a single flat file for simplicity.

## Quick Start

```bash
# Install all scripts to ~/.local/bin
./install-scripts

# Update all installed scripts from the repository
update-scripts

# Uninstall all scripts
./install-scripts --uninstall
```

## Scripts Overview

| Script Name | Description |
| ----------- | ----------- |
| [`install-scripts`](install-scripts) | Dynamic installer script that copies all current and future scripts to `~/.local/bin`, makes them executable, and overwrites existing ones. Registers the repo directory for the `update-scripts` script. |
| [`update-scripts`](update-scripts) | Updates all installed scripts from the original repository directory (registered by `install-scripts`). Skips scripts that are already up-to-date. |
| [`ez-install`](scripts/ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.) that extracts to `~/.local/share`, links binaries to `~/.local/bin`, finds icons, and interactive category selection for `.desktop` shortcuts. |
| [`proton-reset`](scripts/proton-reset) | Steam Proton troubleshooting utility that scans all storage libraries, lists installed games, backs up common savegame folders, deletes `compatdata` to reset Proton, and supports backup restore (`--restore`). |
| [`pkg-update`](scripts/pkg-update) | Package updater (Zypper ref/dup + Flatpak update/cleanup) with an explicit exit prompt. |
| [`install-win-fonts`](scripts/install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites (`ms-fonts`). Executed manually after install. |
| [`goto`](scripts/goto) | Interactive directory bookmark manager — save, select, and jump to frequently used directories with number or letter shortcuts. |
| [`sddm-guest`](scripts/sddm-guest) | Manages SDDM login manager guest account visibility (`hide`, `unhide`, `toggle`, `status`). Automatically creates the `guest` user if missing when unhiding. |
| [`agy-auth`](scripts/agy-auth) | Utility for switching `antigravity-cli` between API Key and Google OAuth authentication modes. |

## Adding a New Script

1. Create a new file under `scripts/` using kebab-case naming: `scripts/my-new-script`
2. Add a shebang line: `#!/usr/bin/env bash`
3. Run `./install-scripts` to deploy it

The installer will automatically pick up any new script in `scripts/` — no configuration changes needed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
