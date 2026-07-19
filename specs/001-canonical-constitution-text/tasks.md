# Tasks: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Concretization**: Full context
**Inputs**: plan.md, spec.md, interface-spec.md, ungrounded-or-unresolvable-constitution.feature

---

## Dependency Graph

Phase 1: Capture tooling and corpus (3 tasks, no upstream phase dependency; T001→T002→T003 sequential) [Shared]
Phase 2: Owner skill surface (2 tasks, depends on Phase 1; T004→T005 sequential) [Shared]

5 tasks total | no parallel phases — a strict pipeline | Builder: single builder

## Branching Guidance

**Pipeline mode**: `spec/001-canonical-constitution-text/base` → `spec/001-canonical-constitution-text/task-1`, `spec/001-canonical-constitution-text/task-2`, …

---

## Phase 1: Capture tooling and corpus [Shared]

- [x] **T001** [Shared] Pin source identity: confirm the capture commit is Constitution 5.0 and record the pinned facts — pinned facts + 5.0 evidence in capture script defaults; [ASSUMED] confirmed via v5.0 tag/release
  - **Scope**: Identify the upstream commit SHA of the holacracyone Constitution markdown that corresponds to version 5.0; verify the correspondence (release tag or holacracy.org cross-check); record SHA, version label `5.0`, and source URL as the capture script's built-in defaults.
  - **Acceptance criteria**:
    - The chosen commit SHA is documented with the evidence tying it to the 5.0 release
    - The three pinned facts (SHA, `5.0`, source URL) exist in exactly one place the capture script reads as defaults
    - The spec's `[ASSUMED]` version-label assumption is either confirmed or escalated before any capture runs
  - **Dependencies**: None
  - **Plan reference**: Phase 1 — Capture tooling and corpus; Risks: 2 (pinned commit is not actually 5.0)
  - **Interface references**: interface-spec.md: Capture script invocation (flag defaults); Manifest contract (header block facts)
  - **Risk**: ⚠️ Version identity — master may have drifted past 5.0; wrong pin makes every citation claim wrong

- [x] **T002** [Shared] Build the capture-and-verify script — 2 scenarios (round-trip abort, byte-for-byte reassembly) verified; failure modes + idempotency tested
  - **Scope**: One standalone dev-time script (no third-party dependencies; language is Builder's choice) implementing the full capture flow: fetch raw markdown at the pinned commit, split at the document's own heading boundaries, emit unit files (YAML frontmatter with the six fields + byte-verbatim body), generate manifest.md (header facts + strict index table), reassemble bodies in document order and byte-compare against the fetched source, write outputs only on an exact match.
  - **Acceptance criteria**:
    - Supports the three override flags (`--commit`, `--version`, `--source-url`) with pinned defaults, per interface-spec.md
    - Produces `references/units/{preamble.md, article-N.md, N.M.md, license.md}` and `references/manifest.md` matching the naming rule and data contracts in interface-spec.md
    - Frontmatter contains exactly: address, heading, parent, version, source_commit, source_url — no file paths
    - Round-trip byte-comparison passes before any file is written; on fetch failure, split ambiguity, or mismatch: non-zero exit, diagnostic to stderr, zero files written
    - Re-running with unchanged inputs is idempotent (byte-identical outputs)
  - **Dependencies**: T001
  - **Plan reference**: Phase 1 — Capture tooling and corpus; ADR-1 (Section-level files), ADR-3 (file-level manifest), ADR-4 (frontmatter + round-trip verification)
  - **Scenario references**: ungrounded-or-unresolvable-constitution.feature: "Scenario: Failed round-trip verification aborts capture with no files written", "Scenario: Reassembled corpus matches the published source byte-for-byte"
  - **Interface references**: interface-spec.md: Capture script invocation; Unit frontmatter contract; Manifest contract; Error Communication (capture-time contract)
  - **Risk**: ⚠️ Structural surprises — lead-in prose under Article headings or inconsistent clause formatting may complicate boundary detection

- [x] **T003** [Shared] Produce, review, and commit the captured corpus — 25 units (Preamble, Articles 1-5, Sections 1.1-5.5, License) + manifest; round-trip byte-exact (52195B); manifest reviewed against source structure, no anomalies
  - **Scope**: Run the capture script against the pinned commit; human-review the generated manifest against the published document's structure (the one-time first-capture review); commit the complete `references/` output set.
  - **Acceptance criteria**:
    - Capture exits 0 with the round-trip byte-comparison passing
    - Manifest rows cover: Preamble, Articles 1–5, every Section N.M, and License — in document order, with headings and parents matching the published text
    - Manifest header carries version `5.0`, source URL, pinned SHA, and capture date
    - Reviewed manifest anomalies (if any) are resolved by fixing the script and re-capturing — never by hand-editing outputs
  - **Dependencies**: T002
  - **Plan reference**: Phase 1 — Capture tooling and corpus (deliverable); Risks: 1 (splitting), Cross-cutting: regeneration-only discipline
  - **Scenario references**: ungrounded-or-unresolvable-constitution.feature: "Scenario: Preamble resolves despite carrying no numeric address", "Scenario: License attribution is an addressable verbatim unit"
  - **Interface references**: interface-spec.md: Structural layout; Manifest contract

## Phase 2: Owner skill surface [Shared]

- [ ] **T004** [Shared] Write the `constitution` owner skill (SKILL.md)
  - **Scope**: Author `skills/constitution/SKILL.md` with the five required sections from the interface accord: Addressing Grammar (all six address forms), Lookup Procedure (manifest-first), Parallel Read Pattern (Articles), Not-Found Rule (two-step deterministic + corpus-unavailable degradation), Regeneration (pointer to the capture script, regeneration-only rule).
  - **Acceptance criteria**:
    - All five required sections present and matching interface-spec.md's structural requirements
    - The not-found rule covers all four error conditions from the interface's runtime table (no manifest row, unit absent from covering body, malformed address, manifest missing/malformed)
    - The lookup procedure walks manifest → covering row → unit file → in-body location, including the Article fan-out
    - No storage-layout details leak into what consumers report as unit metadata
  - **Dependencies**: T003
  - **Plan reference**: Phase 2 — Owner skill surface; ADR-2 (manifest + convention), ADR-5 (single owner directory)
  - **Scenario references**: ungrounded-or-unresolvable-constitution.feature: "Scenario: Unknown address reports not-found", "Scenario: Malformed address reports not-found", "Scenario: Missing manifest makes the corpus unavailable"
  - **Interface references**: interface-spec.md: SKILL.md — required sections; Interactions (consumer flow); Error Communication (runtime not-found contract)

- [ ] **T005** [Shared] Implement the fixed address-resolution checks
  - **Scope**: Implement the end-to-end validation set from the plan's testing strategy — a Section (`1.1`), a clause (`5.3.5(a)`), an Article fan-out (`Article 2`), the Preamble, the License, a known-bad address (`9.9`), a malformed address, and the corpus-unavailable case — exercising the manifest → file → unit flow exactly as SKILL.md instructs, and satisfying the feature file's `@wip` scenarios.
  - **Acceptance criteria**:
    - Every check resolves (or correctly not-founds) per the interface's runtime contract
    - Retrieved metadata for the happy-path checks matches frontmatter and manifest values (heading, parent, version `5.0`, source commit)
    - The 10 spec-derived and proposed `@wip` scenarios in the feature file are demonstrably satisfied (the 2 `@validation` scenarios stay held out for independent verification)
  - **Dependencies**: T004
  - **Plan reference**: Phase 2 — Owner skill surface (validation); Cross-cutting Concerns: testing strategy
  - **Scenario references**: ungrounded-or-unresolvable-constitution.feature: all `@wip` scenarios (12 total; 2 held out as `@validation`)
  - **Interface references**: interface-spec.md: Interactions (consumer flow); Error Communication
