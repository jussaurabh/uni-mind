# Uni-Mind

Persistent, local memory for AI agents. Works with Cursor, Claude Code, and any project — with or without BMAD.

## Install

```bash
git clone https://github.com/<you>/uni-mind.git
cd uni-mind
./setup-memory.sh
```

The script will prompt for the install location (default: `~/.local-memory`). Memory is created at `<path>/memory`. A default `general` lane is created for cross-project work.

Then:

```bash
source ~/.zshrc
```

## Commands

| Command | Description |
|---------|-------------|
| `memory-new <name>` | Create a new project lane in memory |
| `memory-switch <name>` | Switch the active project |
| `memory-reset` | Switch back to `general` (default lane) |
| `link-memory` | Link memory + install rules in current folder |

## Usage

**Create a project and switch to it:**
```bash
memory-new my-product
```

**Link memory into a folder** (project, bmad-model, or any directory):
```bash
cd /path/to/your-project
link-memory
```

`link-memory` will:
- Create `.memory` → your installed memory folder
- Add `.memory` to `.gitignore`
- Install Cursor and Claude Code rules

If memory is already linked, it reports that and exits.

## Optional: BMAD integration

To have `memory-switch` and `memory-new` also update a BMAD hub (e.g. bmad-model), add to `~/.config/uni-mind/config`:
```
HUB_PATH="/path/to/your/bmad-model"
```

## Structure

```
~/.local-memory/memory/          (or your chosen path)
├── BRAIN.md                     # Central index — agents read this first
├── identity/                    # Preferences, conventions, tech stack
├── projects/
│   ├── general/                 # Default lane (created on setup)
│   └── <project>/               # Per-project context, decisions, patterns
├── journal/
│   ├── general/                 # Default lane journal
│   └── <project>/               # Daily work log (one file per day)
├── procedures/                  # Debug, deploy, review flows
└── _setup/                      # Rule templates (cursor, claude)
```
