# Risk: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Round**: 1
**Date**: 2026-07-19
**Artifacts loaded**: spec.md, plan.md, interface-spec.md, PROJECT.md
**Acceptability matrix**: Default 3×3 traffic light

> ⚠ Using default risk acceptability matrix — no project-level matrix found in PROJECT.md.

---

## Risk Register

| H-ID | Hazard | Source | Severity | Probability | Risk Level | Controls | Residual Risk |
|---|---|---|---|---|---|---|---|
| H-1 | Corpus captured from a source that is not Constitution 5.0 (wrong pinned commit / mislabeled version) | spec.md § Versioning & provenance / § Assumptions; plan.md § Risks (2) | High | Low | Yellow | RC-1, RC-7 | Yellow |
| H-2 | Text loss or mis-split during capture — a unit's body is truncated, merged, reordered, or an unnumbered unit (Preamble, License) is dropped | plan.md § Risks (1); spec.md § Capture & fidelity | High | Medium | Red | RC-2, RC-3 | Yellow |
| H-3 | Silent corpus drift after capture — a hand-edit to a unit body breaks byte-exactness invisibly | plan.md § ADR-4, § Risks (3), § Cross-cutting (regeneration-only) | High | Low | Yellow | RC-2, RC-4, RC-7 | Yellow |
| H-4 | Manifest inaccuracy — a valid unit omitted (false not-found) or a wrong path listed (returns another unit's text) | plan.md § ADR-2, § ADR-3; interface-spec.md § Manifest contract | High | Low | Yellow | RC-2, RC-3 | Yellow |
| H-5 | Retrieval returns a best-guess for a malformed or near-miss address instead of not-found (anti-fabrication floor breached) | spec.md § Anti-fabrication floor; interface-spec.md § Error Communication | High | Low | Yellow | RC-5 | Yellow |
| H-6 | Corpus unavailable at runtime (manifest missing/malformed) and consumers guess from file names | interface-spec.md § Error Communication (corpus-unavailable) | Medium | Low | Green | RC-6 | Green |
| H-7 | Upstream source unreachable at capture time (fetch fails) | spec.md § Integration Boundaries (upstream) | Low | Medium | Green | RC-8 | Green |

---

## Hazard Details

### H-1: Capture from a source that is not Constitution 5.0

**Source**: spec.md § Versioning & provenance ("version 5.0 … the published text itself does not declare a version") and § Assumptions (`[ASSUMED]` version label); plan.md § Risks (2).

**Description**: The published document does not self-declare a version, so `5.0` is attached as metadata. If the pinned commit does not actually correspond to the 5.0 release, every retrieved unit is stamped with the wrong version — and every downstream citation is misattributed. This is the failure Principle IV (No Fabricated Citations) exists to prevent, arriving through provenance rather than through the text itself.

**Severity**: High — misattribution is systemic, not local: it taints the entire corpus and the citations of all three consumer agents (spec.md § User Scenarios). The whole feature exists to be the anti-fabrication anchor; a wrong version silently undermines that guarantee.

**Probability**: Low — the master branch is expected to be 5.0, and task T001 fronts the pipeline with an explicit verification. Low, not negligible: master can drift past 5.0 and the check is manual.

**Risk Level**: Yellow (High × Low).

**Controls**:
- **RC-1**: Pre-capture version verification — the pinned commit is confirmed to correspond to the published 5.0 release (tag / holacracy.org cross-check) before any capture runs.
- **RC-7**: Pinned source anchor in metadata (commit + source URL) makes the version claim independently auditable against the published origin at any later time.

**Residual Risk**: Yellow — acceptable with documented justification. Justification: RC-1 gates the capture and RC-7 keeps the claim auditable. The residual is that RC-1 is a manual verification (task T001) not yet performed; it must complete before capture for this to stay Yellow rather than Red.

### H-2: Text loss or mis-split during capture

**Source**: plan.md § Risks (1); spec.md § Capture & fidelity; spec edge cases (Preamble, License, sub-section clauses).

**Description**: The capture script splits the document at its own heading boundaries. Real-document quirks — lead-in prose under Article headings, inconsistent clause formatting, the unnumbered Preamble and trailing license — could cause a unit body to be truncated, merged with a neighbour, reordered, or dropped entirely. Any of these breaks byte-exact fidelity.

**Severity**: High — a corrupted or missing unit yields either wrong cited text (fabrication) or an unresolvable-but-real citation.

**Probability**: Medium — the earlier structural review showed genuine irregularities (lead-in prose, inline lettered clauses, no appendices); splitting logic meets real-world messiness.

**Risk Level**: Red (High × Medium).

**Controls**:
- **RC-2**: Capture-time round-trip byte-comparison — the reassembled corpus must byte-match the fetched source or the capture aborts with zero files written. A mis-split or dropped unit cannot pass reassembly, so this failure mode is loud, not silent.
- **RC-3**: First-capture human review of the generated manifest against the published document structure.

**Residual Risk**: Yellow — RC-2 converts the hazard from silent corruption to a hard build failure, dropping probability to Low. High × Low = Yellow, acceptable: a mis-split fails the byte-comparison rather than shipping.

### H-3: Silent corpus drift after capture

**Source**: plan.md § ADR-4 consequences ("any hand-edit to a body breaks fidelity silently"), § Risks (3), § Cross-cutting Concerns (regeneration-only discipline).

**Description**: After capture, a well-meaning hand-edit to a unit file (fixing a perceived typo, reformatting) breaks byte-exactness without any signal, silently reintroducing fabrication risk.

**Severity**: High — same class as H-2; a drifted body is fabricated cited text carrying false authority.

**Probability**: Low — requires a manual edit against a documented discipline, but there is no automated post-capture guard yet.

**Risk Level**: Yellow (High × Low).

**Controls**:
- **RC-2**: Re-running the capture script re-verifies byte fidelity — the sanctioned mutation path is self-checking.
- **RC-4**: Regeneration-only discipline — generated artifacts are never hand-edited; the only mutation path is re-capture.
- **RC-7**: The pinned source anchor makes drift detectable by re-comparison against the origin commit.

**Residual Risk**: Yellow — acceptable with documented justification. Justification: discipline (RC-4) plus a self-verifying regeneration path (RC-2) plus auditability (RC-7). Residual: no automated post-capture drift detection until CI exists (plan.md § Risks 3 names this as a future add). Worth the developer's attention as the one hazard with no automated runtime guard.

### H-4: Manifest inaccuracy

**Source**: plan.md § ADR-2 ("the not-found guarantee is only as good as the manifest"), § ADR-3 (file-level manifest); interface-spec.md § Manifest contract.

**Description**: The manifest is the single index every retrieval reads first. If it omits a valid unit, real citations report as not-found; if it lists a wrong path or address range, a lookup returns another unit's text — a misattribution.

**Severity**: High — a wrong path produces confidently-wrong cited text; the manifest is the retrieval single point of failure.

**Probability**: Low — the manifest is generated by the same script (not hand-authored) and reviewed once at first capture.

**Risk Level**: Yellow (High × Low).

**Controls**:
- **RC-2**: A unit omitted from the split fails the round-trip reassembly (a gap in document order is detectable).
- **RC-3**: First-capture manifest review against the published structure catches wrong headings/parents/ranges.

**Residual Risk**: Yellow — acceptable. The generated-not-authored manifest plus reassembly and review keep probability Low; residual is that a subtly wrong path that still reassembles correctly relies on RC-3 review to catch.

### H-5: Best-guess retrieval breaches the anti-fabrication floor

**Source**: spec.md § Anti-fabrication floor; spec error scenarios (unknown, malformed); interface-spec.md § Error Communication.

**Description**: For an unknown, malformed, or near-miss address, the retrieval path returns an approximate or nearest-match unit instead of not-found — exactly the fabrication the spec forbids.

**Severity**: High — a plausible wrong passage carrying a citation is worse than none.

**Probability**: Low — the design is explicit and deterministic (two-step not-found, no fuzzy match anywhere); the hazard is an implementation slip, not a design gap.

**Risk Level**: Yellow (High × Low).

**Controls**:
- **RC-5**: Deterministic two-step not-found rule in the owner skill — absent from manifest → not found; unit absent from the covering body → not found; malformed address → not found. No fuzzy fallback exists in the retrieval flow.

**Residual Risk**: Yellow — acceptable. RC-5 is designed-in and verified by the feature's unknown/malformed scenarios; residual reflects only High severity holding the floor above Green at Low probability.

### H-6: Corpus unavailable and consumers guess

**Source**: interface-spec.md § Error Communication (corpus-unavailable degradation rule).

**Description**: If the manifest is missing or malformed, a consumer might fall back to guessing addresses from unit file names rather than reporting the corpus unavailable.

**Severity**: Medium — the honest outcome (report unavailable) is a degradation; only the guessing branch would fabricate, and the rule forbids it.

**Probability**: Low — a committed corpus with a generated manifest is stable; this requires a corrupted deployment.

**Risk Level**: Green (Medium × Low).

**Controls**:
- **RC-6**: Corpus-unavailable degradation rule — manifest missing/malformed → report unavailable, never guess from file names.

**Residual Risk**: Green (accepted) — RC-6 makes the safe behavior the specified one.

### H-7: Upstream source unreachable at capture time

**Source**: spec.md § Integration Boundaries (upstream — read once at capture, pinned).

**Description**: The GitHub-hosted published Constitution is unreachable when the capture script runs, blocking a (re-)capture.

**Severity**: Low — dev-time only. Retrieval reads the committed corpus and is unaffected by upstream availability once captured (spec explicitly: "if the upstream source is unavailable after capture, retrieval is unaffected").

**Probability**: Medium — ordinary network/host availability.

**Risk Level**: Green (Low × Medium).

**Controls**:
- **RC-8**: Pinning plus no-auto-update makes capture reproducible and re-runnable; upstream availability affects only the build step, never live retrieval.

**Residual Risk**: Green (accepted) — a transient build-time inconvenience with no runtime consequence.

---

## Residual Risk Summary

| Level | Count | Hazards |
|---|---|---|
| Red (unacceptable) | 0 | — |
| Yellow (justified) | 5 | H-1, H-2, H-3, H-4, H-5 |
| Green (accepted) | 2 | H-6, H-7 |

**Unacceptable risks**: None. All residual risks are Yellow or Green after controls.

**Where to look**: The five Yellow residuals share one shape — High-severity fidelity/attribution hazards driven down to Low probability by the capture-time round-trip byte-comparison (RC-2), the deterministic not-found rule (RC-5), and the pinned source anchor (RC-7). Two carry a residual worth conscious acceptance: **H-1** stays Yellow only if task **T001** (version verification) is actually performed before capture, and **H-3** has no automated post-capture drift detection until CI exists.

---

## Traceability Index

### Hazards

| ID | Source |
|---|---|
| H-1 | spec.md § Versioning & provenance / § Assumptions; plan.md § Risks (2) |
| H-2 | plan.md § Risks (1); spec.md § Capture & fidelity |
| H-3 | plan.md § ADR-4 / § Risks (3) / § Cross-cutting Concerns |
| H-4 | plan.md § ADR-2 / § ADR-3; interface-spec.md § Manifest contract |
| H-5 | spec.md § Anti-fabrication floor; interface-spec.md § Error Communication |
| H-6 | interface-spec.md § Error Communication (corpus-unavailable) |
| H-7 | spec.md § Integration Boundaries (upstream) |

### Controls

| ID | Mitigates | Grounding |
|---|---|---|
| RC-1 | H-1 | tasks.md T001 — pre-capture version verification |
| RC-2 | H-2, H-3, H-4 | plan.md § ADR-4 — capture-time round-trip byte-comparison |
| RC-3 | H-2, H-4 | plan.md § Risks (1) — first-capture manifest review |
| RC-4 | H-3 | plan.md § Cross-cutting Concerns — regeneration-only discipline |
| RC-5 | H-5 | interface-spec.md § Error Communication — deterministic two-step not-found |
| RC-6 | H-6 | interface-spec.md § Error Communication — corpus-unavailable degradation rule |
| RC-7 | H-1, H-3 | interface-spec.md § Unit frontmatter contract — pinned source anchor |
| RC-8 | H-7 | spec.md § Integration Boundaries — capture-time-only upstream read |
