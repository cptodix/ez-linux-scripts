# Agentic Context & Developer Guide for openSUSE Scripts

This document provides architectural context, conventions, and guidelines for AI coding agents (such as OpenCode, Claude, ChatGPT, Copilot) working with this repository.

## Project Overview
A collection of personal utility and automation scripts designed for openSUSE and Linux environments, optimized for quick terminal execution and desktop integration.

## Core Architecture & Conventions
1. **Naming Convention:**
   - User-facing terminal commands use **kebab-case** and **omit file extensions** (e.g., `update-all`, `goto`, `proton-reset`, `ez-install`).
   - Helper files or source scripts should adhere to clean, descriptive naming without `.sh` where possible.
2. **Repository Structure:**
   ```
   opensuse_scripts/
   ├── install-scripts          # Entry point — scans scripts/*
   ├── update-scripts           # Mirror of scripts/* — scans recursively
   ├── README.md
   ├── AGENTS.md
   ├── LICENSE
   ├── .gitignore
   └── scripts/                 # All script files live directly in scripts/
       ├── agy-switch
       ├── ez-install
       ├── guest-visibility
       ├── goto
       ├── install-win-fonts
       ├── proton-reset
       └── update-all
   ```
   - Each script is a single file directly under `scripts/` with kebab-case naming.
   - No subdirectories — just flat files.
   - Future supporting files (icons, docs, patches, configs) can be added as needed.
3. **Installation (`./install-scripts`):**
   - The repository features a dynamic installer script (`./install-scripts`) that scans all script files under `scripts/`, copies each to `~/.local/bin`, makes them executable (`chmod +x`), and generates corresponding `.desktop` shortcuts in `~/.local/share/applications/`.
   - **Adding a new script:** Create a new file under `scripts/` using kebab-case naming (e.g., `scripts/my-new-script`), add a shebang line, and run `./install-scripts`. Everything else is automatic.
   - **Repo configuration:** `install-scripts` writes the repository directory path directly into the installed `update-scripts` file, replacing a placeholder.
4. **Update (`./update-scripts`):**
   - Reads the hardcoded repository directory from within the installed `update-scripts` file (set by `install-scripts`).
   - Iterates over all script files under `scripts/`, compares each with installed versions, and only overwrites changed files.
   - Regenerates `.desktop` shortcuts and refreshes the desktop database.
5. **Environment & Paths:**
   - Binaries: `~/.local/bin/` (must be in `$PATH`)
   - Shared data/apps: `~/.local/share/`
   - Desktop entries: `~/.local/share/applications/`
   - Proton backups: `~/proton-backups/`

## Scripts Reference
| Script | Type / Purpose |
| ------ | -------------- |
| [`install-scripts`](install-scripts) | Dynamic installer supporting `--dry-run` and `--uninstall`. Deploys binaries to `~/.local/bin` and `.desktop` entries to `~/.local/share/applications`. Writes repo directory into `update-scripts`. |
| [`update-scripts`](update-scripts) | Updates all installed scripts from the repository directory (hardcoded in the script by `install-scripts`). Skips up-to-date scripts. |
| [`ez-install`](scripts/ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.) that extracts to `~/.local/share`, links binaries to `~/.local/bin`, finds icons, and interactive category selection for `.desktop` shortcuts. |
| [`proton-reset`](scripts/proton-reset) | Steam Proton troubleshooting utility that scans all storage libraries, lists installed games, backs up common savegame folders, deletes `compatdata` to reset Proton, and supports backup restore. |
| [`update-all`](scripts/update-all) | Terminal-agnostic system updater (Zypper ref/dup + Flatpak update/cleanup) with an explicit exit prompt. |
| [`install-win-fonts`](scripts/install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites (`ms-fonts`). Executed manually after install. |
| [`goto`](scripts/goto) | Interactive directory bookmark manager — save, select, and jump to frequently used directories with number or letter shortcuts. |
| [`guest-visibility`](scripts/guest-visibility) | Manages SDDM login manager guest account visibility (`hide`, `unhide`, `toggle`, `status`). Automatically creates the `guest` user if missing when unhiding. |
| [`agy-switch`](scripts/agy-switch) | Utility for switching `antigravity-cli` between Gemini API Key mode and Google OAuth mode. |

## Guidelines for AI Agents
- **Do not add file extensions** (`.sh`) to user-facing scripts.
- **New scripts go in `scripts/<name>`** — create a flat file directly under `scripts/` with kebab-case naming.
- **Test installation flow** after adding new scripts by running `./install-scripts`.
- **Test update flow** by modifying a script, then running `update-scripts` to verify it overwrites correctly.
- **Maintain POSIX/Bash compatibility** (`#!/usr/bin/env bash` or `#!/bin/bash`).
- **Keep changes modular and robust**, including error handling and descriptive status messages.
- **When adding new scripts**, update `README.md` and `AGENTS.md` accordingly.
