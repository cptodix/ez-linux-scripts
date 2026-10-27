# Goto Script — Handover Document

## Purpose
`goto` is an interactive directory bookmark manager for openSUSE/Linux. It lets users save, list, select, and delete directory bookmarks, then `cd` into them and run `ls`.

## Key Design Decision: Self-Modifying Script
Bookmarks are stored **as comments inside the script file itself**, not in an external file. This means:
- No separate config file to manage or lose
- The script is its own database
- Bookmarks persist across reboots and script updates (as long as the file exists)

### Bookmark Format
Bookmarks live between two marker comments:
```bash
# BOOKMARK_START
# B:/absolute/path/to/dir
# B:/another/path
# BOOKMARK_END
```

- `# BOOKMARK_START` and `# BOOKMARK_END` are delimiters (never remove these)
- `# B:` prefix identifies a bookmark line
- Path must be absolute (the script converts relative paths automatically)
- Maximum 20 bookmarks

## Architecture

### Core Flow
```
1. Script starts → read entire file into SCRIPT_CONTENT variable
2. Parse bookmarks from SCRIPT_CONTENT (no file I/O needed)
3. Display menu → read user choice
4. Execute action (add/delete/select/quit)
5. If bookmarks changed → regenerate script file with new bookmark block
6. Loop back to step 2
```

### Key Functions
| Function | Purpose |
|----------|---------|
| `load_bookmarks()` | Parses `SCRIPT_CONTENT` for bookmark lines, populates `bookmarks` array |
| `save_bookmarks()` | Regenerates the script file: keeps non-bookmark content, replaces bookmark block |
| `display_menu()` | Shows bookmarks with number + letter shortcuts, action options |
| `add_bookmark()` | Prompts for path, validates directory exists, adds to list |
| `delete_bookmark()` | Prompts for bookmark number(s), removes from list |
| `select_bookmark()` | Resolves number or letter to a bookmark, `cd` + `ls` into it |

### Input Handling
- `read -r -n 1 choice` — reads a single character (no Enter required)
- `read -r dir` — reads a full line (directory path)
- `read -r -p "..." < /dev/tty` — "Press Enter" prompt reads from terminal, NOT stdin (critical fix — see Known Issues)
- `read -r -t 0.1 _drain` — drains the newline left by `-n 1`

### Bookmark Shortcuts
Each bookmark gets two ways to select it:
1. **Number**: 1, 2, 3, ... (up to 20)
2. **Letter**: `a` through `t` (for bookmarks 1–20, offset by 96 in ASCII)

Case ordering in menu: `[Qq]` → `[Aa]` → `[Dd]` → `[0-9]` → `[a-tA-T]`

## Known Issues & Fixes Applied

### Bug 1: Infinite Loop After `add_bookmark`
**Root cause**: The "Press Enter to continue..." prompt used `read -r -p "..."` which reads from stdin. When input was piped (e.g., for testing or automation), this prompt consumed the next character from the pipe instead of waiting for terminal input.

**Trace of the bug**:
```
Input: a\n/tmp\na\n/home\n1\nq\n

1. read -r -n 1 → choice=[a], buffer: \n/tmp\na\n/home\n1\nq\n
2. drain → \n, buffer: /tmp\na\n/home\n1\nq\n
3. read -r dir → dir=[/tmp], buffer: a\n/home\n1\nq\n
4. echo "Added" → echo "" → read -r -p "Press Enter..." → reads "a" (consumed!)
   buffer: /home\n1\nq\n
5. Loop → read -r -n 1 → choice=[/] (first char of /home!)
   → falls through to default case → "Invalid option"
   → loops back → reads "h", "o", "m", "e"... infinite loop!
```

**Fix**: Changed to `read -r -p "Press Enter to continue..." < /dev/tty 2>/dev/null || true`
- Reads from the terminal device, not stdin
- The `|| true` prevents `set -e` from killing the script when `/dev/tty` is unavailable (e.g., in pipes, cron, SSH without TTY)

### Bug 2: "Directory Does Not Exist" Error
**Root cause**: Bookmark line parsing used `${line## B:}` (double `#` for greedy match) which incorrectly stripped characters. The `# B:` prefix contains a literal `#` that needed to be escaped in parameter expansion.

**Fix**: Changed to `${line#\# B:}` (single `#` for non-greedy match, `\#` to escape the literal hash)

### Bug 3: Permission Denied After `save_bookmarks`
**Root cause**: `save_bookmarks()` creates a temp file, writes content, then `mv` replaces the script. The temp file wasn't made executable before the move, so the replaced script lost its execute permission.

**Fix**: Added `chmod +x "$tmp_file"` before `mv "$tmp_file" "$SCRIPT_PATH"`

### Bug 4: stdin Consumption by Bookmark Reading
**Root cause**: Earlier versions used `while ... done < "$SCRIPT_PATH"` to read bookmarks. This redirected stdin for the loop, which interfered with subsequent `read` commands.

**Fix**: Read the entire script into `SCRIPT_CONTENT="$(cat "$SCRIPT_PATH")"` at startup (and after each `save_bookmarks`). Then use here-strings (`<<< "$SCRIPT_CONTENT"`) which don't touch stdin.

## Testing

### Manual Interactive Test
```bash
goto
# Then interactively:
# a → add /tmp → a → add /home → 1 → cd into /tmp → q → quit
```

### Piped Test (Automation / CI)
```bash
# Add two bookmarks, select the second, quit
printf 'a\n/tmp\na\n/home\n2\nq\n' | goto

# Expected output:
#   Menu shows 2 bookmarks
#   Selects /home (bookmark 2), runs ls
#   Quits cleanly
```

### Delete Test
```bash
# Add two bookmarks, delete the second, quit
printf 'a\n/tmp\na\n/home\n2\nq\n' | goto
# Note: '2' selects the bookmark (cd + ls), not delete.
# To delete, use 'd' then enter bookmark number.
```

### Verify Persistence
```bash
# After adding bookmarks, re-run goto — they should still be there
goto
# Check the script file directly:
grep '^# B:' ~/.local/bin/goto
```

## File Locations
| Item | Path |
|------|------|
| Source script | `scripts/goto` |
| Installed script | `~/.local/bin/goto` |
| Bookmarks | Embedded in the installed script file |
| `.desktop` entry | `~/.local/share/applications/goto.desktop` |

## Installation
```bash
cd /home/cptodix/WorkingFolder/Programming/ez-linux-scripts
./install-scripts
# Or update existing installation:
update-scripts
```

## Edge Cases & Behavior
- **Empty input** (just pressing Enter at "Enter directory" prompt): cancels the operation
- **Relative path**: automatically converted to absolute using `$PWD`
- **Non-existent directory**: shows error message, does not add bookmark
- **Duplicate path**: shows "Bookmark already exists" message, does not add
- **More than 20 bookmarks**: shows "Bookmark limit reached (20)" message
- **Bookmark number out of range**: shows error message
- **Script run without TTY**: "Press Enter" prompt fails silently (due to `|| true`)
- **Multiple bookmark deletion**: enter numbers separated by spaces (e.g., `1 3 5`)

## Future Enhancement Ideas
- Search/filter bookmarks by name
- Import/export bookmarks
- Fuzzy matching on directory names
- `cd` only (no `ls`) option
- Configurable default action after selection
- Color-coded output for different directory types
