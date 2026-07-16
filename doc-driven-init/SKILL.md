---
name: doc-driven-init
description: Scaffold a doc-driven Claude Code environment (CLAUDE.md + spec docs + hook) into a project by interviewing the user.
disable-model-invocation: true
---

# doc-driven-init

Stand up a **doc-driven** project environment: one `CLAUDE.md` control surface, a structured
`specs/` doc set, and a real `command-validator` hook — customized to the project by a short
**interview**. You run this by hand; it never fires on its own.

The doc set it produces (the seven living docs):

| File | Role |
|------|------|
| `CLAUDE.md` | the control surface — every session reads it first |
| `specs/pr/pr.md` | living PRD (source of truth for *what*) |
| `specs/pr/HANDOFF.md` | decisions, rationale, REJECTED options (the *why*) |
| `decisions.md` | quick A/B/C point-decision ledger |
| `specs/architecture/ARCHITECTURE.md` | architecture + use-case catalog (the ID taxonomy) |
| `IMPLEMENTATION_STATUS.md` | dated session-log ledger |
| `prompts.md` | raw planning prompts |

Templates live in `templates/` beside this file. The interview and the placeholder→answer map
live in `QUESTIONS.md` beside this file — **read it before Step 1**.

## Step 1 — Interview

Ask the questions defined in `QUESTIONS.md`: the open ones as plain text, the choice ones with
`AskUserQuestion` in its two rounds. Also ask the user for **today's date** (fills `TODAY`; you
cannot read the clock).

**Done when** every placeholder in the `QUESTIONS.md` map has a value or is marked a guided stub,
and the two gate answers (hardware/operator gate → `HIL-checklist.md`; deploy → `deploy/`) are recorded.

## Step 2 — Confirm target

State the target project directory (default: the current working directory) and read back which
optional pieces will be emitted, from the gate answers. Get the user's confirmation.

**Done when** the target path and the optional-set are fixed and confirmed.

## Step 3 — Render the doc set

For each core template — `CLAUDE.md`, `pr.md`, `HANDOFF.md`, `decisions.md`, `ARCHITECTURE.md`,
`IMPLEMENTATION_STATUS.md`, `prompts.md` — copy it to the target and **render** it: substitute
every `{{PLACEHOLDER}}` per the derivation rules in `QUESTIONS.md`.

- Direct and drafted fills → written from the answers, kept short and honest.
- Guided stubs → a one-line `> TODO: <what to fill>` in the project's docs language. Invent no
  domain specifics; write no "N/A".
- `<!-- OPTIONAL … -->` blocks → keep only when their gate says so; otherwise cut the whole block.

**Done when** all seven files exist in the target and a search for `{{` across them returns nothing.

## Step 4 — Render optional pieces

Emit `specs/test/HIL-checklist.md` only if the hardware/operator gate is on. Emit the `deploy/`
folder (`docker-compose.dev.yml`, `backend.Dockerfile`, `README.md`) only if the deploy gate is on.
Render their placeholders the same way.

**Done when** each gated-on piece exists with no `{{` remaining, and each gated-off piece is absent.

## Step 5 — Install the hook

Copy `templates/claude/hooks/command-validator.py` to `<target>/.claude/hooks/` and
`templates/claude/settings.json` to `<target>/.claude/settings.json`. Apply the Round-2 guardrail
choices by editing the `RULES` list in the copied hook. Make the hook executable.

**Done when** `<target>/.claude/hooks/command-validator.py` exists and `<target>/.claude/settings.json`
references it under `hooks.PreToolUse`.

## Step 6 — Summarize

List every file created (grouped: doc set · optional · `.claude/`), then the recommended next
actions: fill the `> TODO:` stubs, define the data model / core contract first (per `HANDOFF.md`
§7), and seed the first real `IMPLEMENTATION_STATUS.md` session-log entry after the first task.

**Done when** the summary is printed.
