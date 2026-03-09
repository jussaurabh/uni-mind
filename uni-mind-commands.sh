#!/bin/zsh
# Uni-Mind commands
# Sourced from ~/.zshrc via: source ~/.config/uni-mind/uni-mind-commands.sh
# Provides: memory-switch, memory-new, memory-reset, link-memory

UNI_MIND_CONFIG="${HOME}/.config/uni-mind/config"
UNI_MIND_ACTIVE="${HOME}/.config/uni-mind/active-project"
if [ -f "$UNI_MIND_CONFIG" ]; then
  source "$UNI_MIND_CONFIG"
else
  echo "Error: Uni-Mind not configured. Run setup-memory.sh from the uni-mind repo."
  return 1
fi

# ============================================================
# memory-switch <project-name>
# Switch the active project
# If HUB_PATH is set (e.g. bmad-model), also updates hub config
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

  # If HUB_PATH set and looks like bmad-model, update config
  if [ -n "${HUB_PATH}" ] && [ -f "${HUB_PATH}/_bmad/bmm/config.yaml" ]; then
    sed -i '' "s|^planning_artifacts:.*|planning_artifacts: \"{project-root}/$1/planning-artifacts\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^implementation_artifacts:.*|implementation_artifacts: \"{project-root}/$1/implementation-artifacts\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_knowledge:.*|project_knowledge: \"{project-root}/$1/docs\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_name:.*|project_name: $1|" "${HUB_PATH}/_bmad/bmm/config.yaml"
  fi

  echo "Switched to: $1"
}

# ============================================================
# memory-new <project-name>
# Create a new project in memory (and hub if HUB_PATH set)
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

  # If HUB_PATH set (bmad-model), create hub structure
  if [ -n "${HUB_PATH}" ] && [ -d "${HUB_PATH}" ]; then
    mkdir -p "${HUB_PATH}/$1"/{planning-artifacts,implementation-artifacts,docs}
  fi

  memory-switch "$1"
  echo "Created project: $1"
  echo "  Memory: $MEMORY_ROOT/projects/$1/"
  [ -n "${HUB_PATH}" ] && [ -d "${HUB_PATH}" ] && echo "  Hub:    ${HUB_PATH}/$1/"
}

# ============================================================
# memory-reset
# Switch back to general (default lane)
# If HUB_PATH set, resets hub config to default
# ============================================================
memory-reset() {
  echo "general" > "$UNI_MIND_ACTIVE"

  if [ -n "${HUB_PATH}" ] && [ -f "${HUB_PATH}/_bmad/bmm/config.yaml" ]; then
    sed -i '' "s|^planning_artifacts:.*|planning_artifacts: \"{project-root}/_bmad-output/planning-artifacts\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^implementation_artifacts:.*|implementation_artifacts: \"{project-root}/_bmad-output/implementation-artifacts\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_knowledge:.*|project_knowledge: \"{project-root}/docs\"|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    sed -i '' "s|^project_name:.*|project_name: default|" "${HUB_PATH}/_bmad/bmm/config.yaml"
    echo "Reset hub to default output (_bmad-output)"
  fi

  echo "Switched to: general"
}

# ============================================================
# link-memory
# Link memory into the current folder + install Cursor and Claude rules
# Run from any project, bmad-model, or other folder
# ============================================================
link-memory() {
  local cwd="$(pwd)"

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

  # Update .gitignore
  if [ -f "$cwd/.gitignore" ]; then
    grep -q "^\.memory$" "$cwd/.gitignore" 2>/dev/null || echo ".memory" >> "$cwd/.gitignore"
  else
    echo ".memory" > "$cwd/.gitignore"
  fi
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
}
