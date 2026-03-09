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
| `link-memory [project]` | Link memory + install rules (optional: set project) |
| `memory-set-project <name>` | Set project for current folder (when no BMAD) |

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

## BMAD integration

When you run `memory-switch` or `memory-new` from inside a BMAD hub (a folder containing `_bmad/`), uni-mind detects it and updates the BMAD config automatically. No extra configuration needed. If BMAD is not installed in that folder (or its parents), only memory is updated.

## .memory-project (project context for agents)

`.memory-project` is a **file** (not a folder) in the workspace root. It contains one line: the project name.

**Role:** When you work in a folder that has **no BMAD** (e.g. a plain repo like `~/Work/projects/metering`), agents need to know which project context to use. They read `.memory-project` to determine:
- Which `projects/<name>/context.md` to load
- Which `journal/<name>/` to read and write
- Which decisions, patterns, lessons files to update

**How to set it:**
- `link-memory metering` — links memory and writes `metering` to `.memory-project`
- `memory-set-project metering` — sets or changes the project for the current folder

**When BMAD is installed:** Agents use `_bmad/bmm/config.yaml` → `project_name` instead. `.memory-project` is only used when BMAD is not present.

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
