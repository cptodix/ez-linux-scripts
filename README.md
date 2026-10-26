# OpenSUSE Scripts

A collection of personal utility and automation scripts for openSUSE and Linux environments, optimized for quick terminal use.

## Scripts Overview

| Script Name | Description |
| ----------- | ----------- |
| [`install-scripts`](install-scripts) | Dynamic installer script that copies all current and future scripts to `~/.local/bin`, makes them executable, and overwrites existing ones. Registers the repo directory for the `update-scripts` script. |
| [`update-scripts`](update-scripts) | Updates all installed scripts from the original repository directory (registered by `install-scripts`). Skips scripts that are already up-to-date. |
| [`ez-install`](ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.) that extracts to `~/.local/share`, links binaries to `~/.local/bin`, finds icons, and interactive category selection for `.desktop` shortcuts. |
| [`proton-reset`](proton-reset) | Steam Proton troubleshooting utility that scans all storage libraries, lists installed games, backs up savefiles/configs, deletes `compatdata` to reset Proton, and supports backup restoration (`--restore`). |
| [`update-all`](update-all) | Refreshes Zypper repositories, performs distribution upgrade (`dup`), updates system-wide Flatpaks, and cleans up unused runtimes. |
| [`install-win-fonts`](install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites to user local fonts directory. |
| [`warp-toggle`](warp-toggle) | Toggles Cloudflare WARP connection status on/off with desktop notifications (`notify-send`). |
| [`guest-visibility`](guest-visibility) | Manages SDDM login manager guest account visibility (hide/show/toggle) on openSUSE (requires `sudo`). |
| [`agy-switch`](agy-switch) | Utility script for managing Gemini API keys and settings modes for `antigravity-cli`. |

## Installation

To install or update all scripts to `~/.local/bin` automatically:

```bash
./install-scripts
```

## Usage

Make sure `~/.local/bin` is in your `$PATH`.

```bash
# Update all scripts from the repository
update-scripts

# Example usage
proton-reset                    # Reset game compatdata & auto-backup saves
proton-reset --restore <backup> # Restore saves into a game compatdata folder
ez-install /path/to/app.tar.gz
update-all
install-win-fonts
warp-toggle
sudo guest-visibility guest toggle
agy-switch api YOUR_API_KEY
```
