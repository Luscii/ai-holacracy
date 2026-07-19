# Checklist: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Checked against**: CONSTITUTION.md (Principles I–V)
**Artifacts checked**: spec.md, plan.md, interface-spec.md, tasks.md, features/ungrounded-or-unresolvable-constitution.feature
**Checks**: 7 (7 pass, 0 fail)
**Generated**: 2026-07-18

---

## Summary

All 7 checks pass. Constitution: 7/7. Done-criteria: not run (no accords). Cross-references: not run (no accords).

All checks are P0 (every applicable principle is a MUST / MUST NOT).

---

## Constitution Checks: 7/7 passed

### Passed (7/7)

**P0** | CONSTITUTION.md I (Source of Truth), calibrated: "the feature establishes a single citable source captured from the published Holacracy Constitution"
→ **spec.md § System Overview / plan.md § System Architecture**: The feature captures the published Constitution 5.0 as one citable source of truth. PASS.

**P0** | CONSTITUTION.md I (Source of Truth), calibrated: "the captured text is addressable at the article / section / rule granularity that citations name"
→ **spec.md § Addressing / interface-spec.md § SKILL.md required sections (Addressing Grammar)**: Six address forms — Preamble, Article N, N.M, N.M.K, N.M.K(a), License. PASS.

**P0** | CONSTITUTION.md II (Never Execute): "MUST NOT submit proposals, capture actions or projects, record governance, or run meetings; no write against a live-governance or execution-tool write API"
→ **plan.md / interface-spec.md / tasks.md**: The capture script writes only local build artifacts at dev time; retrieval is read-only file reads. No org-state mutation and no execution-tool write API anywhere in the design. PASS.

**P0** | CONSTITUTION.md III (Stand Alone): "MUST NOT import or take a runtime dependency on glassfrog-cli or any execution tool; MUST function with the execution tool absent"
→ **plan.md § ADR-2, ADR-5, Implementation Strategy**: Capture script has no third-party dependencies; the whole capability is a self-contained skill (corpus + manifest + script + SKILL.md). Nothing references an execution tool. PASS.

**P0** | CONSTITUTION.md IV (No Fabricated Citations): "every citation MUST resolve to actual constitutional text — no invention or misquote"
→ **plan.md § ADR-4 / spec.md § Capture & fidelity / feature § "Reassembled corpus matches the published source byte-for-byte"**: Byte-exact verbatim bodies proven by capture-time round-trip byte-comparison. PASS.

**P0** | CONSTITUTION.md IV (No Fabricated Citations): "MUST NOT invent, misquote, or misattribute — unknown addresses return nothing, never approximate text"
→ **spec.md § Anti-fabrication floor / interface-spec.md § Error Communication / feature § unknown, malformed, and corpus-unavailable scenarios**: Deterministic two-step not-found with no fuzzy fallback anywhere in the retrieval flow. PASS.

**P0** | CONSTITUTION.md IV (No Fabricated Citations): "MUST NOT misattribute an article, section, or rule"
→ **interface-spec.md § Unit frontmatter contract / § Manifest contract**: Each unit carries address, heading, parent chain, version, and a pinned source anchor (commit + source URL) making every attribution auditable against the published origin. PASS. *(Attribution correctness of the version label is contingent on task T001 — see Governance Notes.)*

---

## Governance Notes

- **No done-\* accords found** (`accords/governance/` is absent). Done-criteria and cross-reference checks were not generated. Consider creating `done-specify.md`, `done-plan.md`, `done-interface.md`, `done-scenarios.md`, and `done-tasks.md` under `accords/governance/` to enable vertical quality checks on each pipeline artifact. Until then, checklist covers constitution principles only.
- **Constitution Principle V (The Human Owns the Tension)**: no applicable checks for this feature. Principle V governs tension-driven advisory and authoring flows; this feature is a static, read-only text source with no such flow. Calibrated to zero checks by design, not skipped by omission.
- **Traceability contingency (Principle IV attribution)**: the version label `5.0` is carried as an `[ASSUMED]` value in spec.md and is verified by task **T001** before any capture runs. The attribution-correctness check passes on the artifacts as written (they honestly flag the assumption and schedule its verification); it does not certify that the pinned commit is in fact 5.0 — that is T001's job at build time.
