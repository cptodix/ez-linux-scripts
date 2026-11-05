# Agentic Context & Developer Guide for openSUSE Scripts

This document provides architectural context, conventions, and guidelines for AI coding agents (such as OpenCode, Claude, ChatGPT, Copilot) working with this repository.

## Project Overview
A collection of personal utility and automation scripts designed for openSUSE and Linux environments, optimized for quick terminal execution and desktop integration.

## Core Architecture & Conventions
1. **Naming Convention:**
   - User-facing terminal commands use **kebab-case** and **omit file extensions** (e.g., `pkg-update`, `goto`, `proton-reset`, `ez-install`).
   - Helper files or source scripts should adhere to clean, descriptive naming without `.sh` where possible.
2. **Repository Structure:**
   ```
   ez-linux-scripts/
   ├── install           # Online installer/uninstaller — downloads repo to temp, installs, cleans up
   ├── update-scripts    # Online updater — downloads repo to temp, syncs, cleans up
   ├── README.md
   ├── AGENTS.md
   ├── LICENSE
   ├── .gitignore
   └── scripts/          # All script files live directly in scripts/
       ├── agy-auth
       ├── ez-install
       ├── goto
       ├── install-win-fonts
       ├── pkg-update
       ├── proton-reset
       └── sddm-guest
   ```
   - Each script is a single file directly under `scripts/` with kebab-case naming.
   - No subdirectories — just flat files.
   - Future supporting files (icons, docs, patches, configs) can be added as needed.
3. **Installation (`./install`):**
   - The installer is fully **online**: it downloads the repository as a GitHub archive, extracts it into a temporary directory, and performs the installation from there. The temp directory is removed automatically when done — no local clone is kept.
   - It copies every shebang-bearing script under `scripts/` to `~/.local/bin`, makes them executable, and generates corresponding `.desktop` shortcuts in `~/.local/share/applications/`.
   - It also adds `alias goto='. goto'` to `~/.bashrc` (idempotent), prompts whether to run `install-win-fonts` (default: no), and installs a self-contained `update-scripts`.
   - Supports `--dry-run` (preview) and `--uninstall` (remove everything it installs).
   - **Adding a new script:** Create a new file under `scripts/` using kebab-case naming (e.g., `scripts/my-new-script`), add a shebang line, commit & push to the remote, then run `update-scripts` (or `./install` on a fresh system). Everything else is automatic.
4. **Update (`update-scripts`):**
   - The updater is also fully **online**: it downloads the repository as a GitHub archive, extracts it into a temporary directory, compares each script under `scripts/` with the installed version, and only overwrites changed files.
   - Regenerates `.desktop` shortcuts and refreshes the desktop database.
   - The temporary directory is removed automatically when done.
   - There is **no persistent `REPO_DIR` configuration** anymore — the repo URL and branch are hardcoded inside the script, so it works anywhere.
5. **Environment & Paths:**
   - Binaries: `~/.local/bin/` (must be in `$PATH`)
   - Shared data/apps: `~/.local/share/`
   - Desktop entries: `~/.local/share/applications/`
   - Proton backups: `~/proton-backups/`

## Scripts Reference
| Script | Type / Purpose |
| ------ | -------------- |
| [`install`](install) | Online installer/uninstaller supporting `--dry-run` and `--uninstall`. Downloads the repo to a temp dir, deploys binaries to `~/.local/bin` and `.desktop` entries to `~/.local/share/applications`, adds the goto alias, then cleans up. |
| [`update-scripts`](update-scripts) | Online updater. Downloads the repo to a temp dir, syncs installed scripts (skips up-to-date ones), regenerates shortcuts, then cleans up. |
| [`ez-install`](scripts/ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.) that extracts to `~/.local/share`, links binaries to `~/.local/bin`, finds icons, and interactive category selection for `.desktop` shortcuts. |
| [`proton-reset`](scripts/proton-reset) | Steam Proton troubleshooting utility that scans all storage libraries, lists installed games, backs up common savegame folders, deletes `compatdata` to reset Proton, and supports backup restore. |
| [`pkg-update`](scripts/pkg-update) | Package updater (Zypper ref/dup + Flatpak update/cleanup) with an explicit exit prompt. |
| [`install-win-fonts`](scripts/install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites (`ms-fonts`). Executed manually after install. |
| [`goto`](scripts/goto) | Interactive directory bookmark manager — save, select, and jump to frequently used directories with numeric shortcuts. |
| [`sddm-guest`](scripts/sddm-guest) | Manages SDDM login manager guest account visibility (`hide`, `unhide`, `toggle`, `status`). Automatically creates the `guest` user if missing when unhiding. |
| [`agy-auth`](scripts/agy-auth) | Utility for switching `antigravity-cli` between API Key and Google OAuth authentication modes. |

## Guidelines for AI Agents
- **Do not add file extensions** (`.sh`) to user-facing scripts.
- **New scripts go in `scripts/<name>`** — create a flat file directly under `scripts/` with kebab-case naming.
- **Test installation flow** with `./install --dry-run` (previews actions without writing). Since `install` fetches from the remote, changes must be committed & pushed first to exercise the real online flow.
- **Test update flow** by modifying a script, then running `update-scripts` to verify it overwrites the installed copy from the remote.
- **Maintain POSIX/Bash compatibility** (`#!/usr/bin/env bash` or `#!/bin/bash`).
- **Keep changes modular and robust**, including error handling and descriptive status messages.
- **When adding new scripts**, update `README.md` and `AGENTS.md` accordingly.
