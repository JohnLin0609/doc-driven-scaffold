# {{PROJECT_NAME}} — Development Handoff & Decision History

**Purpose:** This file hands off the planning discussion to a fresh development session. It
captures the *background, decisions, rationale, rejected options, and known traps* so the next
session doesn't re-litigate settled questions.

**Authoritative spec:** `pr.md` is the source of truth for *what to build*. This file explains
*why*. If the two ever conflict, `pr.md` wins for requirements; this file wins for rationale.

**Status as of handoff:** {{HANDOFF_STATUS}}

---

## 1. What we're building (one paragraph)
{{ONE_PARAGRAPH}}

## 2. The single most important architectural decision
{{KEY_DECISION}}

**Therefore:** {{KEY_DECISION_CONSEQUENCE}}

## 3. {{CRITICAL_MODEL_HEADING}}
{{CRITICAL_MODEL}}

<!-- e.g. the security model, the consistency model, the core invariant. State the principle,
     then the concrete rules it mandates. -->

## 4. The subtle rules (read carefully)
{{SUBTLE_RULES}}

<!-- The non-obvious constraints that a fresh session would get wrong. Each rule: the rule, the
     trap it resolves, and (if it's a common mistake) an explicit "do NOT do X". -->

## 5. Things explicitly REJECTED (so they don't get reconsidered)
{{REJECTED_OPTIONS}}

<!-- Format each as:  ❌ <option>. → <what we do instead>. -->

## 6. Confirm-later (not blocking the start of development)
{{CONFIRM_LATER}}

## 7. Suggested first steps for the dev session
{{FIRST_STEPS}}

<!-- Usually: 1) read pr.md alongside this file; 2) define the data model / core contract first
     (it encodes most decisions above); 3) build the riskiest seam as a proof-of-concept. -->
