# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
{{PROJECT_OVERVIEW}}

{{ARCH_ONE_LINER}}

**Authoritative docs (read before proposing changes):**
- `specs/pr/pr.md` — source of truth for requirements.
- `specs/pr/HANDOFF.md` — rationale, decisions, and explicitly rejected options.
- `specs/architecture/ARCHITECTURE.md` — approved architecture (final § = use-case catalog).
- `IMPLEMENTATION_STATUS.md` — session history + Known Issues (read to avoid re-investigating deferred items).

**Status:** {{STATUS_LINE}}

## Commands
{{COMMANDS_INTRO}}

```bash
# One-time setup
{{SETUP_COMMANDS}}

# Run / dev stack
{{RUN_COMMANDS}}

# Tests
{{TEST_COMMANDS}}
```

## Architecture (the big picture)

**The spine ({{DATA_OR_CONTROL}} flow):** {{THE_SPINE}}

{{ARCHITECTURE_NOTES}}

- The final section of `specs/architecture/ARCHITECTURE.md` is the traceable **use-case catalog**
  ({{UC_PREFIX}}-* IDs referenced throughout tests).

### Development method: {{TEST_APPROACH}}
{{DEV_METHOD_NOTES}}

<!-- OPTIONAL — keep only if the project has a hardware / operator-in-the-loop acceptance gate -->
Acceptance for anything {{HIL_SCOPE}} is signed off against `specs/test/HIL-checklist.md`.
<!-- /OPTIONAL -->

## Conventions & rules

- **NEVER use `rm -rf`** — blocked by the `command-validator` hook (`.claude/hooks/command-validator.py`).
  Use `rm <file>` for files, `rmdir` for empty dirs.
- **Language:** project docs are in **{{DOCS_LANGUAGE}}**; keep code, identifiers, and technical
  terms in English.
- **Directory roles:** `/src` = formal code; `/src-xxxx` = purpose-built tools (each needs a
  README); `/specs` = requirements & review artifacts.
- **`reference/`** = vendor datasheets / external source material. **Search here before the internet.**
- Work only on the feature branch (`{{FEATURE_BRANCH}}`), never `main`. **Ask before pushing.**
- After implementing: add/update tests and verify they pass; then update `IMPLEMENTATION_STATUS.md`
  (technical detail + a dated session-log entry).
