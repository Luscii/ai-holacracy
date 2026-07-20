# Validate: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Round**: 1 of 3
**Date**: 2026-07-19
**Verdict**: Ready
**Artifacts loaded**: spec.md, plan.md, tasks.md, interface-spec.md, features/ungrounded-or-unresolvable-constitution.feature, PROJECT.md
**Implementation files**: skills/constitution/ — SKILL.md, scripts/capture, scripts/check-addresses, references/manifest.md, references/units/*.md (25 units)

---

## Conformance Summary

| Dimension | Status | Findings |
|---|---|---|
| Driving scenario coverage | ✓ Pass | 0 |
| Acceptance criteria | ✓ Pass | 0 |
| Interface contract conformance | ✓ Pass | 0 |
| Non-behavior absence | ✓ Pass | 0 |
| @wip lifecycle completion | ✓ Pass | 0 |
| **Validation scenarios** | ✓ Satisfied | 0 |

**Total**: 5 dimensions checked, 5 passed, 0 findings. Both held-out validation scenarios satisfied.

---

## Driving Scenario Coverage

**Status**: Pass (8 of 8 scenarios covered)

Every driving scenario in spec.md § Driving Scenarios has an identifiable code path through the manifest → covering row → unit file → in-body location flow documented in SKILL.md. The `scripts/check-addresses` harness exercises each against the committed corpus (10/10 checks pass).

| Scenario | Status | Implementation |
|---|---|---|
| Retrieve a Section by address (`1.1`) | ✓ Covered | references/units/1.1.md + SKILL.md § Lookup Procedure; harness `_section` |
| Retrieve an Article, incl. nested units (`Article 2`) | ✓ Covered | references/units/article-2.md + 2.*.md + SKILL.md § Parallel Read Pattern; harness `_article` |
| Retrieve a rule-grain clause (`5.3.5(a)`) | ✓ Covered | references/units/5.3.md (in-body clause) + SKILL.md § Lookup Procedure; harness `_clause` |
| Unknown address returns not-found (`9.9`) | ✓ Covered | manifest has no covering row + SKILL.md § Not-Found Rule; harness `_unknown` |
| Malformed address not best-guessed | ✓ Covered | SKILL.md § Not-Found Rule (six-form grammar); harness `_malformed` |
| Retrieve the unnumbered Preamble | ✓ Covered | references/units/preamble.md; harness `_preamble` |
| Retrieve the license attribution | ✓ Covered | references/units/license.md; harness `_license` |
| Sub-section incl. lettered clauses (`5.3.5`) | ✓ Covered | references/units/5.3.md; harness `_subsection` (clauses a–f in order) |

---

## Acceptance Criteria

**Status**: Pass (5 of 5 tasks complete, all criteria met)

All tasks in tasks.md are checked. Each task's acceptance criteria have supporting implementation evidence.

| Task | Status | Evidence |
|---|---|---|
| T001 Pin source identity | ✓ Met | Three pinned facts as single-source defaults in scripts/capture; docstring records v5.0 tag/release evidence; the spec's `[ASSUMED]` version item confirmed (not escalated) |
| T002 Capture-and-verify script | ✓ Met | `--commit`/`--version`/`--source-url` with pinned defaults; produces units + manifest per naming and data contracts; six-field frontmatter; round-trip byte-compare gates all writes; failure modes abort with zero writes; idempotent |
| T003 Produce/review/commit corpus | ✓ Met | Capture exits 0; 25 committed units cover Preamble, Articles 1–5, all 18 Sections, License in document order; manifest header carries version 5.0, source URL, pinned SHA, capture date |
| T004 Owner skill SKILL.md | ✓ Met | Five required sections present; not-found rule covers all four runtime conditions; lookup walks manifest → row → file → in-body incl. Article fan-out; metadata boundary forbids path/storage leak |
| T005 Address-resolution checks | ✓ Met | scripts/check-addresses resolves/not-founds the fixed address set per the runtime contract; happy-path metadata matches frontmatter (heading, parent, version 5.0, source commit); 10 @wip scenarios satisfied, 2 @validation held out |

---

## Interface Contract Conformance

**Status**: Pass (all surfaces conformant)

Implementation compared against interface-spec.md.

| Surface | Status | Evidence |
|---|---|---|
| Structural layout | ✓ Conformant | SKILL.md, references/manifest.md, units/preamble.md, article-1..5.md (5/5), N.M.md (18/18), license.md, scripts/capture all present |
| Naming rule (basename = address prefix) | ✓ Conformant | 5.3.md covers 5.3/5.3.K/5.3.K(a); article-2.md + 2.*.md cover Article 2 — verified via harness |
| Manifest contract | ✓ Conformant | Header block (Version, Source URL, Source commit, Captured); index table with the four-column set (Address prefix, File, Heading, Parent) in document order; no content excerpts |
| Unit frontmatter contract | ✓ Conformant | All 25 units carry exactly the six fields in order; no file paths |
| Capture script invocation | ✓ Conformant | Three named flags with pinned defaults, per contract |
| SKILL.md required sections | ✓ Conformant | Addressing Grammar, Lookup Procedure, Parallel Read Pattern, Not-Found Rule, Regeneration |
| Error communication | ✓ Conformant | Runtime not-found (all four conditions) in SKILL.md; capture-time abort in scripts/capture |

---

## Non-Behavior Absence

**Status**: Pass (no excluded behavior present)

| Non-behavior (spec.md § Non-Behaviors) | Status | Evidence |
|---|---|---|
| Must not judge/verify a *claimed* citation matches its text | ✓ Absent | Skill body implements retrieval + not-found only; no claim-matching/judging code. SKILL.md's "check that a claimed citation resolves" framing mirrors the spec's own `.feature` Rule and User Scenario wording (the consumer, CR&V, does the checking; this capability retrieves). Capture-time byte-verification is corpus fidelity, not runtime citation verification. |
| Must not copy/distribute source to the three agents | ✓ Absent | No distribution mechanism; single owner directory (ADR-5). Distribution deferred to spec 003. |
| Must not interpret/summarize/teach/paraphrase | ✓ Absent | Unit bodies are byte-verbatim (round-trip proven); no transformation of text |
| Must not auto-update on upstream change | ✓ Absent | Capture is a manual dev-time tool pinned to a commit; the only network call (`urlopen`) lives in scripts/capture, absent from SKILL.md and all runtime consumer paths; no watch/poll/cron/auto-update |
| Must not return approximate/nearest-match text | ✓ Absent | SKILL.md § Not-Found Rule forbids substitution; harness `_unknown`/`_malformed` confirm not-found with no nearest-match |

---

## @wip Lifecycle Completion

**Status**: Pass

The feature file retains `@wip` only on the two `@validation` scenarios (lines 52, 108), which were held out from the Builder by design and are not referenced as removable by any checked task. All ten Builder-owned `@wip` tags were removed in T005. No stale `@wip` remains on implemented scenarios.

---

## Validation Scenario Results

**Status**: Satisfied (2 of 2 scenarios traced to implementation)

These were held out from the implementing agent and verified here against independent evidence — a fresh re-fetch of the upstream source at the pinned commit and a first-principles inspection of every unit's frontmatter, not the capture script's own checks.

| Scenario | Status | Trace |
|---|---|---|
| No implementation leakage in retrieved metadata | ✓ Satisfied | Independent inspection of all 25 units: each carries exactly {address, heading, parent, version, source_commit, source_url}. `source_url` is an upstream `https://` provenance URL (the spec's "source reference for the unit"), not a local path; no field value exposes a file path or storage layout. Local paths appear only in the manifest, and SKILL.md § Lookup Procedure's metadata boundary forbids consumers surfacing them. |
| Round-trip fidelity across the whole document | ✓ Satisfied | Re-fetched the upstream source at pinned commit 0a93cbd (52,195 bytes) and reassembled the 25 committed unit bodies (frontmatter stripped) in manifest document order (52,195 bytes): byte-for-byte identical, with no gaps, duplications, or reordering. |

---

## Verdict: Ready

All 5 conformance dimensions pass with zero findings. Both held-out validation scenarios are satisfied through independent verification. The implementation conforms to its specification: the Constitution 5.0 corpus is captured byte-exact, addressable at every specified granularity, retrievable one unit at a time, and the anti-fabrication floor (deterministic not-found, no substitution) holds. The specification loop is closed.

---

## Next Steps

Implementation conforms to the specification. Suggest PR review and merge.
