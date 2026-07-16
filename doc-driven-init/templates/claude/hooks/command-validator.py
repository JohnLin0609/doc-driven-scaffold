#!/usr/bin/env python3
"""command-validator — a Claude Code PreToolUse hook that blocks destructive shell commands.

Wired via .claude/settings.json under hooks.PreToolUse (matcher "Bash"). Reads the tool-call
JSON on stdin; if the Bash command matches a destructive pattern it DENIES the call and tells
Claude what to do instead. Pure stdlib; no dependencies.

Deny contract: emit the PreToolUse JSON decision AND exit non-zero, so it works whether the
runtime honors the JSON block or the exit code.
"""
import json
import re
import shlex
import sys

# Extra guardrails toggled by doc-driven-init's Round-2 answers. Flip to True to enable.
WARN_ON_GIT_PUSH = False
BLOCK_SECRET_WRITES = False  # blocks writes/edits to .env, *.pem, id_rsa, etc.

_SEGMENT_SPLIT = re.compile(r"[\n;|]|&&|\|\||&")
_SECRET_TARGET = re.compile(r"(^|/)(\.env(\.\w+)?|id_[a-z]+|.*\.pem|.*\.key|.*\.p12)$", re.I)


def deny(reason: str) -> None:
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": reason,
                }
            }
        )
    )
    print(f"command-validator: {reason}", file=sys.stderr)
    sys.exit(2)


def segments(command):
    """Split a compound command into individual invocations."""
    return [s.strip() for s in _SEGMENT_SPLIT.split(command) if s.strip()]


def tokens(segment):
    try:
        return shlex.split(segment)
    except ValueError:
        return segment.split()


def is_rm_force_recursive(toks):
    """True when an `rm` invocation carries BOTH recursive and force flags, in any form
    (`-rf`, `-fr`, `-r -f`, `--recursive --force`, `-Rf`, ...)."""
    if not toks or toks[0].split("/")[-1] != "rm":
        return False
    recursive = force = False
    for t in toks[1:]:
        if t == "--recursive":
            recursive = True
        elif t == "--force":
            force = True
        elif t.startswith("-") and not t.startswith("--"):
            letters = t[1:]
            if "r" in letters or "R" in letters:
                recursive = True
            if "f" in letters:
                force = True
    return recursive and force


def check_segment(seg):
    toks = tokens(seg)

    if is_rm_force_recursive(toks):
        deny(
            "`rm -rf` (recursive force-delete) is blocked. Use `rm <file>` for a single file or "
            "`rmdir` for an empty directory. To remove a tree deliberately, delete its contents "
            "explicitly or ask the user to run it."
        )

    if WARN_ON_GIT_PUSH and toks[:2] == ["git", "push"]:
        deny(
            "`git push` is guarded — pushing is outward-facing. Confirm with the user, then run "
            "it yourself or have them run it."
        )

    if BLOCK_SECRET_WRITES:
        base = toks[0].split("/")[-1] if toks else ""
        if base in {"tee", "cp", "mv"} or (base in {"vi", "vim", "nano"}):
            for t in toks[1:]:
                if _SECRET_TARGET.search(t):
                    deny(f"Writing to a secret file (`{t}`) is blocked.")
        if re.search(r">>?\s*\S*(\.env|\.pem|\.key|id_[a-z]+)", seg, re.I):
            deny("Redirecting into a secret file is blocked.")


def main():
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)  # nothing to inspect; allow

    if payload.get("tool_name") != "Bash":
        sys.exit(0)

    command = (payload.get("tool_input") or {}).get("command", "")
    if not command:
        sys.exit(0)

    # Whole-command checks (patterns that span shell separators).
    if re.search(r":\s*\(\s*\)\s*\{\s*:\s*\|\s*:\s*&\s*\}\s*;\s*:", command):
        deny("Fork bomb pattern is blocked.")

    for seg in segments(command):
        check_segment(seg)

    sys.exit(0)  # allow


if __name__ == "__main__":
    main()
