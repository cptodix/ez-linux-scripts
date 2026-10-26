# Agentic Context & Developer Guide for openSUSE Scripts

This document provides architectural context, conventions, and guidelines for AI coding agents (such as OpenCode, Claude, ChatGPT, Copilot) working with this repository.

## Project Overview
A collection of personal utility and automation scripts designed for openSUSE and Linux environments, optimized for quick terminal execution and desktop integration.

## Core Architecture & Conventions
1. **Naming Convention:** 
   - User-facing terminal commands use **kebab-case** and **omit file extensions** (e.g., `update-all`, `warp-toggle`, `proton-reset`, `ez-install`).
   - Helper files or source scripts should adhere to clean, descriptive naming without `.sh` where possible.
2. **Installation (`./install`):**
   - The repository features a dynamic installer script (`./install`) that scans all script files in the root directory (excluding `install`, `README.md`, `LICENSE`, `AGENTS.md`, `update`, and hidden files), copies them to `~/.local/bin`, makes them executable (`chmod +x`), and generates corresponding `.desktop` shortcuts in `~/.local/share/applications/`.
   - **Adding a new script:** Any new script added to the root directory is **automatically** installed, symlinked, and given a `.desktop` shortcut by `./install` without modifying the installer itself.
   - **Repo registration:** `install` stores the repository directory path in `$HOME/.local/etc/opensuse-scripts-repo-dir` for the `update` script.
3. **Update (`./update`):**
   - Reads the stored repo directory from the config file created by `install`.
   - Iterates over all scripts in the repo (same exclusion list), compares with installed versions, and only overwrites changed files.
   - Regenerates `.desktop` shortcuts and refreshes the desktop database.
4. **Environment & Paths:**
   - Binaries: `~/.local/bin/` (must be in `$PATH`)
   - Shared data/apps: `~/.local/share/`
   - Desktop entries: `~/.local/share/applications/`
   - Proton backups: `~/proton-backups/`
   - Config: `$HOME/.local/etc/opensuse-scripts-repo-dir` (repo directory path)

## Scripts Reference
| Script | Type / Purpose |
| ------ | -------------- |
| [`install`](install) | Dynamic installer supporting `--dry-run` and `--uninstall`. Deploys binaries to `~/.local/bin` and `.desktop` entries to `~/.local/share/applications`. Registers repo directory for `update`. |
| [`update`](update) | Updates all installed scripts from the registered repository directory. Skips up-to-date scripts. |
| [`ez-install`](ez-install) | Universal archive installer (`.tar.gz`, `.zip`, `.AppImage`, etc.). Extracts to `~/.local/share`, links binary, finds icons, and provides an interactive category picker for `.desktop` creation. |
| [`proton-reset`](proton-reset) | Steam Proton troubleshooting utility. Scans all Steam storage libraries (`libraryfolders.vdf`), lists installed games, automatically backs up savefiles/configs (`Documents`, `Saved Games`, `AppData`), wipes `compatdata` to reset Proton, and supports restoration (`--restore`). |
| [`update-all`](update-all) | Terminal-agnostic system updater (Zypper ref/dup + Flatpak update/cleanup) with an explicit exit prompt. |
| [`install-win-fonts`](install-win-fonts) | Downloads and installs complete Microsoft Windows & Office 365 font suites (`ms-fonts`). |
| [`warp-toggle`](warp-toggle) | Toggles Cloudflare WARP connection status with desktop notifications (`notify-send`). |
| [`guest-visibility`](guest-visibility) | Manages SDDM login manager guest account visibility (`hide`, `unhide`, `toggle`, `status`). Automatically creates the `guest` user if missing when unhiding. |
| [`agy-switch`](agy-switch) | Utility for switching `antigravity-cli` between Gemini API Key mode and Google OAuth mode. |

## Guidelines for AI Agents
- **Do not add file extensions** (`.sh`) to user-facing scripts.
- **Test installation flow** after adding new scripts by running `./install`.
- **Test update flow** by modifying a script, then running `update` to verify it overwrites correctly.
- **Maintain POSIX/Bash compatibility** (`#!/usr/bin/env bash` or `#!/bin/bash`).
- **Keep changes modular and robust**, including error handling and descriptive status messages.
- **When adding new scripts**, update `README.md` and `AGENTS.md` accordingly.
