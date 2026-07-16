#!/usr/bin/env bash
# Install the doc-driven-init skill into a project's .claude/skills/.
#
# Copy-paste-and-run — no edits needed. Installs into the current directory by
# default, or into a project path passed as the first argument:
#
#   ./install.sh              # installs into $PWD
#   ./install.sh ~/code/myapp # installs into that project
#
# Re-running is safe: it replaces any existing copy of the skill.
set -euo pipefail

REPO="JohnLin0609/doc-driven-scaffold"
REPO_URL="https://github.com/${REPO}.git"
SKILL="doc-driven-init"

TARGET="${1:-$PWD}"
DEST="${TARGET%/}/.claude/skills"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Fetching ${SKILL} from ${REPO} ..."
if command -v gh >/dev/null 2>&1; then
  gh repo clone "$REPO" "$TMP/src" -- --depth 1 --quiet
else
  git clone --depth 1 --quiet "$REPO_URL" "$TMP/src"
fi

mkdir -p "$DEST"
rm -rf "${DEST:?}/${SKILL}"
cp -r "$TMP/src/${SKILL}" "$DEST/${SKILL}"
chmod +x "$DEST/${SKILL}/templates/claude/hooks/command-validator.py" 2>/dev/null || true

echo "Installed: ${DEST}/${SKILL}"
echo "Next: restart Claude Code in ${TARGET} (or run /skills), then invoke /${SKILL}"
