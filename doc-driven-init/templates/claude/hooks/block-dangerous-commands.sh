#!/bin/bash
# block-dangerous-commands — a Claude Code PreToolUse hook (matcher "Bash") that blocks
# destructive shell commands before they execute.
#
# Base derived from Matt Pocock's git-guardrails-claude-code (scripts/block-dangerous-git.sh),
# MIT-licensed — https://github.com/mattpocock/skills. See THIRD_PARTY_NOTICES.md.
# Extended here with rm -rf / fork-bomb patterns (the guardrails the doc-driven method wants).
#
# Requires: jq. Wired via .claude/settings.json under hooks.PreToolUse.
# Contract: on a match, print BLOCKED: ... to stderr and exit 2 (deny). Otherwise exit 0 (allow).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

DANGEROUS_PATTERNS=(
  # --- Matt Pocock's git guardrails (block-dangerous-git.sh) ---
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
  # --- doc-driven additions: recursive force-delete (-R and -r are both recursive) ---
  "\brm\b.*-[a-zA-Z]*[rR][a-zA-Z]*f"  # rm -rf, -Rf, -rfv (recursive before f in one flag)
  "\brm\b.*-[a-zA-Z]*f[a-zA-Z]*[rR]"  # rm -fr, -fR (f before recursive in one flag)
  "\brm\b.*-[rR][a-zA-Z]* +-f"        # rm -r -f / rm -R -f (separate short flags)
  "\brm\b.*-f[a-zA-Z]* +-[rR]"        # rm -f -r / rm -f -R
  "\brm\b.*--recursive.*--force"      # long flags, either order
  "\brm\b.*--force.*--recursive"
  "\brm\b.*--recursive.* +-f"         # mixed long/short
  "\brm\b.*-[rR].* +--force"
  # --- doc-driven additions: fork bomb ---
  ":\(\) *\{ *: *\| *: *& *\} *; *:"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from doing this. Use a safe alternative (e.g. 'rm <file>' / 'rmdir' for deletes) or ask the user to run it." >&2
    exit 2
  fi
done

exit 0
