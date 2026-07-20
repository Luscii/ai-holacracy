# Learnings

Operational patterns discovered during implementation. Each entry records a non-trivial finding that future specs should account for. Managed by the implement skill via memory-protocol.md.

---

## Findings

### 2026-07-19 — Address grammar validates shape; the manifest validates existence
(Found during PR #5 review triage of [001-canonical-constitution-text](../../specs/001-canonical-constitution-text/tasks.md))

- **Type**: design-issue
- **Location**: skills/constitution/scripts/check-addresses (`_FORM_ARTICLE`); applies to any resolver over the corpus (spec 002 Citation Resolution & Verification)
- **Severity**: low — no behavioral impact, but a recurring point of confusion for reviewers and future resolver authors
- **Description**: A resolver's address-form regexes check *shape* only; the manifest is the sole authority on *existence*. A well-formed address naming no captured unit (`Article 6`, `9.9`) is not-found via the "no manifest row" branch — NOT "malformed". The spec's own examples set this precedent: `9.9` (well-formed `N.M`, no row) is the *"Unknown address"* not-found; `"section one point one"` (no grammar form) is the *malformed* case. Do not bake existence facts (e.g. "articles are 1–5") into a grammar regex — it conflates shape with existence and breaks symmetry with the section path.
- **Suggested action**: When spec 002 builds its citation resolver, keep the grammar/existence split: regexes gate the six address forms; the manifest gates existence. Both paths converge on the same consumer behavior (report unresolvable, never substitute), so classification differences are internal only.
