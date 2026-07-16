# Implementation Status

Project: {{PROJECT_NAME}}. Authoritative requirements: `specs/pr/pr.md`
(rationale in `specs/pr/HANDOFF.md`).

## Current phase
{{CURRENT_PHASE}}

<!-- One or two sentences: what is built, what is the current release gate, what is deferred. -->

## Components
{{COMPONENTS_MAP}}

<!-- A short map: `src/foo/` — what it is. Keep it current; it's the fastest orientation for a
     fresh session. -->

## Known issues / deferred
{{KNOWN_ISSUES}}

<!-- Items intentionally left undone, so a future session doesn't re-investigate them. -->

## Session log

<!-- Reverse-chronological. Append a new entry after every implementation session. Format:
     ### YYYY-MM-DD — <headline>
     - What was built / decided, grounded in the reference docs, with the code paths touched.
     - Tests: <count> passed / <count> skipped. New: <test names>. -->

### {{TODAY}} — project scaffolded (doc-driven environment)
- Initialized the doc set (CLAUDE.md, pr.md, HANDOFF.md, decisions.md, ARCHITECTURE.md, this
  file) and the `command-validator` hook via the `doc-driven-init` skill.
- Next: fill in the domain specifics and define the data model / core contract first.
