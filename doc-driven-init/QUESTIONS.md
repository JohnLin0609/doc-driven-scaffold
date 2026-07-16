# The interview

The single source of truth for what `doc-driven-init` asks and where each answer lands. The
interview is deterministic: same answers → same rendered doc set.

Ask the **open** questions as plain text in the conversation. Ask the **choice** questions with
`AskUserQuestion`, batched into the two rounds shown (≤4 per call). Offer the listed default as
the recommended option.

**Every choice round must leave the user-insertable free-text option available** — the user can
always type their own answer instead of picking a listed one. `AskUserQuestion` renders this as
the "Other" option automatically; never suppress or work around it. When a user's free-text
answer arrives, treat it as the value for that field verbatim.

## Open questions (plain text)

| # | Question | Fills |
|---|----------|-------|
| O1 | Project name? | `PROJECT_NAME`, `COMPOSE_PROJECT_NAME` (slug) |
| O2 | One-line purpose (a tagline)? | used in `PROJECT_OVERVIEW` lead |
| O3 | 2–4 sentence overview: what it does, its scale, and its hardest constraint? | `PROJECT_OVERVIEW`, `PROJECT_BACKGROUND`, `ONE_PARAGRAPH` |
| O4 | Primary language + key frameworks/libraries? | `PRIMARY_LANGUAGE`, `FRAMEWORKS`, drafts the `*_COMMANDS`, `BASE_IMAGE`, `DEPS_FILE`, `INSTALL_COMMAND`, `START_COMMAND` |
| O5 | The spine — the end-to-end path a primary request takes through the system? | `THE_SPINE` |
| O6 | The single most important principle/invariant (the thing every change must respect)? | `CRITICAL_MODEL`, `CRITICAL_MODEL_HEADING`, `KEY_DECISION`, `INVARIANTS` |
| O7 | Feature branch name? (default `feat/<slug>-implementation`) | `FEATURE_BRANCH` |
| O8 | Use-case ID prefix? (default `UC`) | `UC_PREFIX` |

## Choice questions — Round 1 (`AskUserQuestion`)

| # | Question | Options (default first) | Fills / gates |
|---|----------|-------------------------|---------------|
| C1 | Architecture shape? | three-tier · client-server · single-service · other | `ARCH_SHAPE`, `ARCH_ONE_LINER`, `TIERS`, `DATA_OR_CONTROL` |
| C2 | Docs language? | Traditional Chinese · English · other | `DOCS_LANGUAGE` |
| C3 | Testing approach? | BDD→TDD + hardware/operator gate · TDD (unit+integration) · lightweight / manual | `TEST_APPROACH`, `DEV_METHOD_NOTES` |
| C4 | Does the project have a hardware or operator-in-the-loop acceptance gate? | no · yes | **gates** `specs/test/HIL-checklist.md` + the OPTIONAL block in `CLAUDE.md` |

## Choice questions — Round 2 (`AskUserQuestion`)

| # | Question | Options (default first) | Fills / gates |
|---|----------|-------------------------|---------------|
| C5 | Generate a `deploy/` docker-compose stack? | yes · no | **gates** the `deploy/` folder |
| C6 | Extra guardrails for the command-validator hook? (multi-select) | block `rm -rf` (always on) · warn on `git push` · block writes to secret files | edits `command-validator.py` RULES |

## Derivation rules

- **Direct fills** — `PROJECT_NAME`, `DOCS_LANGUAGE`, `FEATURE_BRANCH`, `UC_PREFIX`, and `TODAY`
  (= the render date; ask the user for today's date, since you cannot read the clock) go in verbatim.
- **Drafted fills** — `PROJECT_OVERVIEW`, `ARCH_ONE_LINER`, `THE_SPINE`, `CRITICAL_MODEL(_HEADING)`,
  `TEST_APPROACH`, `DEV_METHOD_NOTES`, `STATUS_LINE` ("Scaffolded — no code yet"), `TIERS`, and the
  `*_COMMANDS` are written from the answers. Keep them short and honest.
- **Guided stubs** — domain fields the interview does not cover (`REQUIREMENTS`, `NON_GOALS`,
  `SUBTLE_RULES`, `REJECTED_OPTIONS`, `DATA_MODEL`, the `decisions.md` body, `UC` catalog rows, the
  `HIL_*` rows, `KNOWN_ISSUES`): replace the placeholder with a one-line `> TODO: <what to fill>`
  in `DOCS_LANGUAGE`. Do not invent domain specifics; do not write "N/A".
- **Optional blocks** — anything wrapped in `<!-- OPTIONAL … -->` (and the whole `HIL-checklist.md`
  / `deploy/` folder) is emitted only when its gate answer says so; otherwise omit it entirely.
- **`INITIAL_PROMPT`** — capture the user's own framing of the project verbatim.
