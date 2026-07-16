# doc-driven-scaffold

A reusable capture of the **doc-driven** Claude Code setup: one rich `CLAUDE.md` as the whole
control surface, backed by a structured `specs/` document set and a real safety hook. Instead of
a `.claude/` harness of sub-agents and slash commands, the project's judgment lives in a small
set of long-lived markdown files that every session reads first.

This pattern is generalized from a production project. It trades tooling for **legibility**: a
new session (human or Claude) gets oriented by reading documents, and every implementation
session leaves its trace in the same documents.

## What's in the box

```
doc-driven-scaffold/
├── README.md            ← you are here
└── doc-driven-init/     ← the skill (self-contained; copy this one folder to install)
    ├── SKILL.md         ← user-invoked: interview → render → install → summarize
    ├── QUESTIONS.md     ← the interview question bank + placeholder→answer map
    └── templates/       ← everything the skill renders into a target project
        ├── CLAUDE.md
        ├── decisions.md
        ├── prompts.md
        ├── IMPLEMENTATION_STATUS.md
        ├── specs/pr/pr.md
        ├── specs/pr/HANDOFF.md
        ├── specs/architecture/ARCHITECTURE.md
        ├── specs/test/HIL-checklist.md          (optional; gated by the interview)
        ├── claude/settings.json
        ├── claude/hooks/command-validator.py    (a REAL rm -rf blocker)
        └── deploy/                              (optional; gated by the interview)
```

## The doc set (what the skill produces)

| File | Role |
|------|------|
| `CLAUDE.md` | The control surface. Overview · authoritative-docs pointers · status · commands · architecture ("the spine") · development method · conventions & rules. |
| `specs/pr/pr.md` | Living PRD — the source of truth for *what to build*. Refined in place with dated `Review note (rev. …)` banners; ends in a Decisions Log. |
| `specs/pr/HANDOFF.md` | The *why*: numbered decisions, rationale, and **explicitly REJECTED** options, so a fresh session doesn't re-litigate settled questions. The project "constitution." |
| `decisions.md` | Quick A/B/C point-decision ledger; `❯` marks the choice. |
| `specs/architecture/ARCHITECTURE.md` | Approved architecture; its final section is a **use-case catalog** of stable IDs that tests reference. |
| `IMPLEMENTATION_STATUS.md` | Reverse-chronological, dated **session log** — the mandated ledger updated after every task. |
| `prompts.md` | Raw planning prompts, kept verbatim. |
| `specs/test/HIL-checklist.md` | *(optional)* hardware / operator-in-the-loop acceptance gate, keyed to the use-case IDs. |

## Install

**One-liner (recommended)** — from the target project's root, paste and run as-is (no edits):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JohnLin0609/doc-driven-scaffold/main/install.sh)
```

Private-repo note: the raw URL needs auth, so if the `curl` form 404s, clone-then-run instead —
this uses the GitHub CLI credentials and works the same:

```bash
gh repo clone JohnLin0609/doc-driven-scaffold /tmp/dds -- --depth 1 && bash /tmp/dds/install.sh; rm -rf /tmp/dds
```

Either form installs the skill into `./.claude/skills/doc-driven-init` (or pass a project path:
`install.sh ~/code/myapp`). Re-running is safe — it replaces any existing copy. Then restart
Claude Code in that project (or run `/skills`) and invoke `/doc-driven-init`.

**Manual copy** — the skill is self-contained (`templates/` and `QUESTIONS.md` live inside its one
folder), so a single `cp -r` also works, project-level or global:

```bash
mkdir -p .claude/skills && cp -r /path/to/doc-driven-scaffold/doc-driven-init .claude/skills/doc-driven-init   # project
cp -r /path/to/doc-driven-scaffold/doc-driven-init ~/.claude/skills/doc-driven-init                            # global
```

Notes:
- Project-level keeps the skill scoped to one repo and out of your global config; if the skill
  exists in both locations, the **project** copy wins.
- The invocation name comes from the `name:` field in `SKILL.md` (`doc-driven-init`), not the
  folder name — keep them matching if you rename.

## Use

In a target project's directory, run the skill and answer the interview:

```
/doc-driven-init
```

It asks a handful of specific questions (project name, the spine, the core invariant, docs
language, architecture shape, testing approach, whether there's a hardware gate, whether to
generate `deploy/`, …), then renders a customized `CLAUDE.md` + doc set into the project and
installs the hook. Fields it can't derive from your answers become `> TODO:` lines for you to
fill — it never fabricates domain detail.

## Use the templates without the skill

Everything under `doc-driven-init/templates/` is a plain file with `{{PLACEHOLDER}}` markers.
Copy the ones you want and fill the placeholders by hand — the skill is a convenience, not a
requirement.

## The hook

`templates/claude/hooks/command-validator.py` is a real `PreToolUse` hook (matcher `Bash`, pure
stdlib) that denies destructive commands (`rm -rf` and friends) and tells Claude what to do
instead. `templates/claude/settings.json` wires it. Test it directly:

```bash
echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf build"}}' \
  | python3 doc-driven-init/templates/claude/hooks/command-validator.py; echo "exit=$?"
# → prints a deny decision, exit=2

echo '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' \
  | python3 doc-driven-init/templates/claude/hooks/command-validator.py; echo "exit=$?"
# → no output, exit=0 (allowed)
```
