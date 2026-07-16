# {{PROJECT_NAME}} — Architecture

Approved architecture. Written in {{DOCS_LANGUAGE}}; code/identifiers in English. Every use-case
in the catalog (final section) maps to at least one test.

## 1. Overview
{{ARCH_OVERVIEW}}

## 2. Components / tiers
{{TIERS}}

<!-- One subsection per component. For each: responsibility, the data it owns, and the interfaces
     it exposes. -->

## 3. The spine ({{DATA_OR_CONTROL}} flow)
{{THE_SPINE}}

<!-- The end-to-end path a primary request takes through the components. This is the single most
     important diagram/paragraph — the thing every change must respect. -->

## 4. Key invariants
{{INVARIANTS}}

<!-- The rules that must hold no matter what. e.g. "identity always comes from X, never Y";
     "the tap path is fail-closed"; "sync is idempotent". -->

## 5. Data model
{{DATA_MODEL}}

## 6. Cross-cutting concerns
{{CROSS_CUTTING}}

<!-- config, auth, retention, observability, error handling — whatever applies. -->

---

## 7. Use-case catalog
The traceable taxonomy. Each ID is stable and referenced from tests (and the HIL checklist, if
any). Add rows as scope grows; never renumber an existing ID.

| ID | Use case | Primary component | Test(s) |
|----|----------|-------------------|---------|
| {{UC_PREFIX}}-01 | {{UC_01}} | {{UC_01_COMPONENT}} | {{UC_01_TEST}} |
| {{UC_PREFIX}}-02 | {{UC_02}} | {{UC_02_COMPONENT}} | {{UC_02_TEST}} |
