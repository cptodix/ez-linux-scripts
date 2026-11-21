# ez-linux-scripts

A collection of personal utility and automation scripts for openSUSE and Linux, built for quick terminal use and desktop integration.

No cloning needed — installation and updates pull straight from the remote repository.

## Install

One command installs everything (all scripts, desktop shortcuts, and the updater):

```bash
curl -fsSL https://raw.githubusercontent.com/cptodix/ez-linux-scripts/main/install | bash
```

What the installer does:

- Downloads the latest repository into a temporary directory, then deletes it when done
- Copies every script into `~/.local/bin` and makes it executable
- Creates `.desktop` shortcuts in `~/.local/share/applications/`
- Adds the `goto` alias to `~/.bashrc`
- Installs `update-scripts` so you can update later
- Offers to install the Windows fonts (default: no)

Preview what it will do without making changes:

```bash
./install --dry-run
```

> After installing, open a new terminal (or run `source ~/.bashrc`) so the `goto` alias is available.

## Update

```bash
update-scripts
```

Fetches the latest repository and overwrites only the scripts that actually changed. No arguments needed.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/cptodix/ez-linux-scripts/main/install | bash -s -- --uninstall
```

Or with a local `install` copy:

```bash
./install --uninstall
```

This removes the installed scripts and their desktop shortcuts. Your fonts, bookmarks, and other personal files are left alone.

## Scripts

Every script below is installed as a command in `~/.local/bin`. The examples assume that directory is on your `$PATH`.

### `ez-install` — install a downloaded app from an archive or AppImage

Unpacks an archive (`.tar.gz`, `.tgz`, `.tar.xz`, `.txz`, `.tar.bz2`, `.tbz2`, `.zip`) or an AppImage, stores it under `~/.local/share`, links the program into `~/.local/bin`, finds an icon, and creates a desktop shortcut (asking for a category when the app doesn't provide one).

```bash
ez-install ~/Downloads/SomeApp.tar.gz
ez-install ~/Downloads/tool.zip
ez-install ~/Downloads/SomeApp.AppImage
```

Archives are extracted to `~/.local/share/<app-name>/`; AppImages are stored in `~/.local/share/appimages/`.

### `pkg-update` — update the whole system (openSUSE + Flatpak)

Refreshes zypper, runs a full distribution upgrade, updates Flatpaks, and removes unused ones — then waits for you to press Enter. It opens its own terminal window (konsole, gnome-terminal, and a few others are supported).

```bash
pkg-update
```

> `pkg-update` uses `zypper dup` (full upgrade) and asks for your sudo password.

### `proton-reset` — reset a Steam game's Proton prefix

Scans all your Steam libraries (native and Flatpak), lists installed games, backs up the common save folders, then deletes the game's `compatdata` folder so Proton rebuilds it fresh on the next launch. You can restore a backup afterward.

```bash
proton-reset                    # list games, pick number(s), back up + reset
proton-reset --restore <file>   # restore a previous backup (then pick the game)
```

Interactively it asks for a game number — or several, space-separated. Backups are saved under `.../steamapps/compatdata/<appid>/backup/`.

### `install-win-fonts` — install the Microsoft font suites

Downloads the Windows, Office 365, and Aptos fonts, installs them to `~/.local/share/fonts/ms-fonts`, and rebuilds the font cache.

```bash
install-win-fonts
```

> Also offered at the end of `install` (default: no).

### `goto` — bookmark and jump between directories

A numeric bookmark manager for folders. It runs through a sourced alias, so `cd` changes your *current* shell.

```bash
goto        # open the menu
goto 3      # jump straight to bookmark #3
```

In the menu: `a` add a bookmark, `d` delete (comma-separated numbers, or `a` for all), `q` quit, or type a number to jump. Up to 20 bookmarks are stored in `~/.config/goto/bookmarks`.

> Needs the `alias goto='. goto'` line in `~/.bashrc` (the installer adds it). Open a new shell after installing.

### `sddm-guest` — show or hide a guest account on the SDDM login screen

Needs root. Defaults to the user `guest` and the `toggle` action.

```bash
sudo sddm-guest                # toggle (hide if visible, show if hidden)
sudo sddm-guest status         # show the current state
sudo sddm-guest hide           # hide from the login screen
sudo sddm-guest unhide         # show on the login screen (creates the user if missing)
sudo sddm-guest guest2 hide    # operate on a different user
```

> `unhide` creates the account with password `guest` if it does not exist.

### `agy-auth` — switch the antigravity-cli authentication mode

Switches `antigravity` between a Google AI Studio API key and Google OAuth, then launches `agy`.

```bash
agy-auth api      # use an API key (reads GEMINI_API_KEY, or prompts silently)
agy-auth oauth    # use Google OAuth
```

For API mode you can export the key first:

```bash
export GEMINI_API_KEY=your_key_here
agy-auth api
```

Extra flags are passed through to `agy`, e.g. `agy-auth api --some-flag`.

> Never pass the key as a command argument — it would be saved to your shell history.

## Requirements

- openSUSE (`zypper`) for `pkg-update`; Flatpak optional
- `curl` or `wget`, plus `tar`, for install/update
- `python3` for `agy-auth`
- Steam for `proton-reset`, SDDM for `sddm-guest`
- `wget`, `unzip`, and `fc-cache` for `install-win-fonts`

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

This project is licensed under the GNU Affero General Public License v3.0. See the [LICENSE](LICENSE) file for details.
