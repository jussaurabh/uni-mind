#!/bin/zsh
# Uni-Mind commands
# Sourced from ~/.zshrc via: source ~/.config/uni-mind/uni-mind-commands.sh
# Provides: memory-switch, memory-new, memory-reset, link-memory, memory-set-project
#
# BMAD detection: memory-switch, memory-new, memory-reset detect BMAD by walking
# from cwd upward for _bmad/bmm/config.yaml. link-memory and memory-set-project
# do not need BMAD (they manage .memory symlink and .memory-project only).

UNI_MIND_CONFIG="${HOME}/.config/uni-mind/config"
UNI_MIND_ACTIVE="${HOME}/.config/uni-mind/active-project"
if [ -f "$UNI_MIND_CONFIG" ]; then
  source "$UNI_MIND_CONFIG"
else
  echo "Error: Uni-Mind not configured. Run setup-memory.sh from the uni-mind repo."
  return 1
fi

# Walk from dir upward; return first dir containing _bmad/bmm/config.yaml
_find_bmad_hub() {
  local dir="$1"
  dir="$(cd "$dir" 2>/dev/null && pwd -P)" || return 1
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    [ -f "$dir/_bmad/bmm/config.yaml" ] && echo "$dir" && return 0
    dir="${dir:h}"
  done
  return 1
}

# ============================================================
# memory-switch <project-name>
# Switch the active project
# If BMAD hub found (from cwd upward), updates its config
# ============================================================
memory-switch() {
  if [ -z "$1" ]; then
    echo "Usage: memory-switch <project-name>"
    echo ""
    echo "Available projects:"
    ls -d "$MEMORY_ROOT/projects"/*/ 2>/dev/null | xargs -I{} basename {} | grep -v "^$"
    return 1
  fi

  if [ ! -d "$MEMORY_ROOT/projects/$1" ]; then
    echo "Error: Project '$1' not found in memory"
    echo ""
    echo "Available projects:"
    ls -d "$MEMORY_ROOT/projects"/*/ 2>/dev/null | xargs -I{} basename {}
    echo ""
    echo "Use 'memory-new $1' to create it."
    return 1
  fi

  echo "$1" > "$UNI_MIND_ACTIVE"

  # If BMAD hub found (from cwd upward), update its config
  local hub
  hub="$(_find_bmad_hub "$(pwd)" 2>/dev/null)" && [ -n "$hub" ] && {
    sed -i '' "s|^planning_artifacts:.*|planning_artifacts: \"{project-root}/$1/planning-artifacts\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^implementation_artifacts:.*|implementation_artifacts: \"{project-root}/$1/implementation-artifacts\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_knowledge:.*|project_knowledge: \"{project-root}/$1/docs\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_name:.*|project_name: $1|" "$hub/_bmad/bmm/config.yaml"
    echo "  Updated BMAD config at $hub"
  }

  echo "Switched to: $1"
}

# ============================================================
# memory-new <project-name>
# Create a new project in memory (and hub structure if BMAD found from cwd)
# ============================================================
memory-new() {
  if [ -z "$1" ]; then
    echo "Usage: memory-new <project-name>"
    return 1
  fi

  if [ -d "$MEMORY_ROOT/projects/$1" ]; then
    echo "Project '$1' already exists. Switching to it."
    memory-switch "$1"
    return 0
  fi

  # Create memory project folder
  mkdir -p "$MEMORY_ROOT/projects/$1"
  mkdir -p "$MEMORY_ROOT/journal/$1"
  cat > "$MEMORY_ROOT/projects/$1/context.md" << 'TMPL'
# Project Context

<!-- Product overview, repos involved, architecture summary -->
<!-- Agents read this to understand what this project is -->

## Overview

## Repos

## Architecture Summary
TMPL
  cat > "$MEMORY_ROOT/projects/$1/decisions.md" << 'TMPL'
# Decision Log

<!-- Why we chose X over Y — append-only -->
<!-- Format: ## YYYY-MM-DD HH:MM: Brief Title -->
TMPL
  cat > "$MEMORY_ROOT/projects/$1/patterns.md" << 'TMPL'
# Code Patterns

<!-- Established patterns, API conventions, folder structures for this project -->
TMPL
  cat > "$MEMORY_ROOT/projects/$1/lessons.md" << 'TMPL'
# Lessons Learned

<!-- What went wrong, what worked, what to never do again -->
<!-- Format: ## YYYY-MM-DD HH:MM: Brief Title -->
TMPL

  # If BMAD hub found (from cwd upward), create hub structure
  local hub
  hub="$(_find_bmad_hub "$(pwd)" 2>/dev/null)" && [ -n "$hub" ] && {
    mkdir -p "$hub/$1"/{planning-artifacts,implementation-artifacts,docs}
    echo "  Created hub structure at $hub/$1/"
  }

  memory-switch "$1"
  echo "Created project: $1"
  echo "  Memory: $MEMORY_ROOT/projects/$1/"
}

# ============================================================
# memory-reset
# Switch back to general (default lane)
# If BMAD hub found (from cwd), resets its config to default
# ============================================================
memory-reset() {
  echo "general" > "$UNI_MIND_ACTIVE"

  local hub
  hub="$(_find_bmad_hub "$(pwd)" 2>/dev/null)" && [ -n "$hub" ] && {
    sed -i '' "s|^planning_artifacts:.*|planning_artifacts: \"{project-root}/_bmad-output/planning-artifacts\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^implementation_artifacts:.*|implementation_artifacts: \"{project-root}/_bmad-output/implementation-artifacts\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_knowledge:.*|project_knowledge: \"{project-root}/docs\"|" "$hub/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_name:.*|project_name: default|" "$hub/_bmad/bmm/config.yaml"
    echo "  Reset BMAD config at $hub"
  }

  echo "Switched to: general"
}

# ============================================================
# link-memory [project-name]
# Link memory into the current folder + install Cursor and Claude rules
# Optional: pass project name to set .memory-project (agents use this when BMAD not installed)
# ============================================================
link-memory() {
  local cwd="$(pwd)"
  local project="$1"

  if [ -z "$MEMORY_ROOT" ] || [ ! -d "$MEMORY_ROOT" ]; then
    echo "Error: Memory not found at $MEMORY_ROOT"
    echo "Re-run setup-memory.sh from the uni-mind repo."
    return 1
  fi

  # Already linked?
  if [ -L "$cwd/.memory" ]; then
    local target="$(cd "$cwd/.memory" 2>/dev/null && pwd -P)"
    local mem_abs="$(cd "$MEMORY_ROOT" 2>/dev/null && pwd -P)"
    if [ -n "$target" ] && [ "$target" = "$mem_abs" ]; then
      echo "Memory already linked in this folder: .memory -> $MEMORY_ROOT"
      [ -n "$project" ] && echo "$project" > "$cwd/.memory-project" && echo "  Set project: $project"
      return 0
    else
      echo "Memory already linked to a different location: .memory -> $target"
      echo "Unlink first if you want to point to: $MEMORY_ROOT"
      return 1
    fi
  fi

  # .memory exists but is not a symlink?
  if [ -e "$cwd/.memory" ]; then
    echo "A .memory file or directory already exists (not a symlink)."
    echo "Remove it to use link-memory."
    return 1
  fi

  # Create symlink
  ln -s "$MEMORY_ROOT" "$cwd/.memory"
  echo "Linked: .memory -> $MEMORY_ROOT"

  # Set project for this folder (agents read .memory-project when BMAD not installed)
  if [ -n "$project" ]; then
    echo "$project" > "$cwd/.memory-project"
    echo "Set project: $project"
  fi

  # Update .gitignore
  for entry in .memory .memory-project; do
    if [ -f "$cwd/.gitignore" ]; then
      grep -q "^${entry}$" "$cwd/.gitignore" 2>/dev/null || echo "$entry" >> "$cwd/.gitignore"
    else
      echo "$entry" > "$cwd/.gitignore"
    fi
  done
  echo "Updated .gitignore"

  # Install Cursor rule
  mkdir -p "$cwd/.cursor/rules"
  cp "$MEMORY_ROOT/_setup/cursor-rule.mdc" "$cwd/.cursor/rules/bmad-memory.mdc"
  echo "Installed Cursor rule: .cursor/rules/bmad-memory.mdc"

  # Install Claude Code rule
  mkdir -p "$cwd/.claude/rules"
  cp "$MEMORY_ROOT/_setup/claude-rule.md" "$cwd/.claude/rules/bmad-memory.md"
  echo "Installed Claude Code rule: .claude/rules/bmad-memory.md"

  echo ""
  echo "Done. Memory is accessible from this folder."
  echo "Agents will read .memory/BRAIN.md at session start."
  [ -z "$project" ] && echo "Tip: Run 'link-memory <project>' or 'memory-set-project <project>' to set project for this folder."
}

# ============================================================
# memory-set-project <project-name>
# Set the project for the current folder (writes .memory-project)
# Agents read this when BMAD is not installed to know which project context to use
# ============================================================
memory-set-project() {
  local cwd="$(pwd)"
  if [ -z "$1" ]; then
    echo "Usage: memory-set-project <project-name>"
    [ -f "$cwd/.memory-project" ] && echo "Current: $(cat "$cwd/.memory-project")"
    return 1
  fi
  if [ ! -d "$cwd/.memory" ] && [ ! -L "$cwd/.memory" ]; then
    echo "Error: Memory not linked in this folder. Run link-memory first."
    return 1
  fi
  echo "$1" > "$cwd/.memory-project"
  grep -q "^\.memory-project$" "$cwd/.gitignore" 2>/dev/null || echo ".memory-project" >> "$cwd/.gitignore"
  echo "Set project for this folder: $1"
}
