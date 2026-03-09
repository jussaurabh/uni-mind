#!/bin/zsh
# Uni-Mind Memory Setup
# Standalone installer. Run after cloning uni-mind.
# Usage: ./setup-memory.sh

set -e

UNI_MIND_REPO="${0:A:h}"
TEMPLATES="${UNI_MIND_REPO}/memory-templates"
CONFIG_DIR="${HOME}/.config/uni-mind"
DEFAULT_PARENT="${HOME}/.local-memory"

echo "Uni-Mind — Memory Setup"
echo "======================"
echo ""
echo "Where should memory be installed?"
echo "  (Enter parent directory. Memory will be created at <path>/memory)"
echo "  Default: ${DEFAULT_PARENT}"
echo ""
read "INSTALL_PARENT?Install location [${DEFAULT_PARENT}]: " || true
INSTALL_PARENT="${INSTALL_PARENT:-$DEFAULT_PARENT}"
INSTALL_PARENT="${INSTALL_PARENT/#\~/$HOME}"
# Normalize: strip trailing slash, append /memory
INSTALL_PARENT="${INSTALL_PARENT%/}"
MEMORY_ROOT="${INSTALL_PARENT}/memory"

echo ""
echo "Memory will be installed at: ${MEMORY_ROOT}"
echo ""

# 1. Create memory directory structure
mkdir -p "${MEMORY_ROOT}"/{identity,projects,procedures,journal/general,agents}
echo "[1/6] Created memory directory structure"

# 2. Create default "general" lane (projects/general + journal/general)
GENERAL_TEMPLATES="${UNI_MIND_REPO}/memory-templates/projects/general"
if [ -d "$GENERAL_TEMPLATES" ]; then
  mkdir -p "${MEMORY_ROOT}/projects/general" "${MEMORY_ROOT}/journal/general"
  for f in context.md decisions.md patterns.md lessons.md; do
    [ -f "${GENERAL_TEMPLATES}/$f" ] && [ ! -f "${MEMORY_ROOT}/projects/general/$f" ] && cp "${GENERAL_TEMPLATES}/$f" "${MEMORY_ROOT}/projects/general/"
  done
  echo "  Created default lane: general"
fi
echo "[2/6] Created general memory lane"

# 3. Copy protocol files (BRAIN, _setup)
if [ ! -f "${MEMORY_ROOT}/BRAIN.md" ]; then
  cp "${TEMPLATES}/BRAIN.md" "${MEMORY_ROOT}/"
  echo "  Created BRAIN.md"
fi
mkdir -p "${MEMORY_ROOT}/_setup"
cp "${TEMPLATES}/_setup"/* "${MEMORY_ROOT}/_setup/"
echo "[3/6] Copied BRAIN.md (if new) and rule templates (_setup/)"

# 4. Copy identity and procedures (only if not exists)
for dir in identity procedures; do
  mkdir -p "${MEMORY_ROOT}/${dir}"
  for f in "${TEMPLATES}/${dir}"/*; do
    [ -f "$f" ] || continue
    dest="${MEMORY_ROOT}/${dir}/${f:t}"
    if [ ! -f "$dest" ]; then
      cp "$f" "$dest"
      echo "  Created ${dir}/${f:t}"
    fi
  done
done
echo "[4/6] Seeded identity/ and procedures/ (skipped existing files)"

# 5. Write config and install uni-mind commands
mkdir -p "$CONFIG_DIR"
echo "MEMORY_ROOT=\"${MEMORY_ROOT}\"" > "${CONFIG_DIR}/config"
echo "general" > "${CONFIG_DIR}/active-project"
cp "${UNI_MIND_REPO}/uni-mind-commands.sh" "${CONFIG_DIR}/uni-mind-commands.sh"
echo "[5/6] Installed uni-mind commands to ${CONFIG_DIR}/"

# 6. Add source to .zshrc
ZSH_SOURCE="source ${CONFIG_DIR}/uni-mind-commands.sh"
if grep -q "uni-mind-commands" ~/.zshrc 2>/dev/null; then
  echo "[6/6] uni-mind commands already sourced in ~/.zshrc"
else
  echo "" >> ~/.zshrc
  echo "# Uni-Mind" >> ~/.zshrc
  echo "$ZSH_SOURCE" >> ~/.zshrc
  echo "[6/6] Added source to ~/.zshrc"
fi

echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "  1. Run:  source ~/.zshrc"
echo "  2. In any folder (project, bmad-model, etc.):  link-memory"
echo "     This creates .memory symlink and installs Cursor/Claude rules."
echo ""
