# Plan: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Role**: Shaper
**Inputs**: spec.md, PROJECT.md (SOUL.md absent; no process memory — first planning run)

---

## System Architecture

The feature has three parts: a **captured corpus** (the Constitution 5.0 split into
addressable unit files), a **manifest** (the generated index that makes addresses resolvable
and not-found deterministic), and a **capture tool** (a dev-time script that produces both
from the pinned upstream commit and proves fidelity). All three live inside one owner skill,
`constitution`, whose SKILL.md documents the addressing scheme and lookup procedure for every
consumer — the Coach, Editor, and Judge agents, and the downstream Citation Resolution &
Verification capability.

```
skills/constitution/
  SKILL.md                     — owner skill: addressing scheme, lookup procedure, not-found rule
  references/
    manifest.md                — generated index: every retrievable file, its address range,
                                 heading, parent chain, version, pinned source anchor
    units/
      preamble.md              — verbatim Preamble
      article-1.md             — Article 1 heading + any lead-in prose before section 1.1
      1.1.md … 5.x.md          — one file per Section (N.M), containing all its
                                 sub-sections and lettered clauses
      license.md               — verbatim Creative Commons attribution
  scripts/
    capture.(sh|py)            — dev-time capture-and-verify tool (never invoked at runtime)
```

**Capture flow (dev-time)**: capture script fetches the raw markdown at the pinned commit →
splits it at structural boundaries derived from the document's own headings → writes unit
files (verbatim body + additive metadata frontmatter) → generates manifest.md → reassembles
all bodies in document order and byte-compares against the fetched source. A capture that
fails the byte-comparison fails loudly and writes nothing.

**Retrieval flow (runtime)**: a consumer holding an address reads manifest.md (small, always
first), finds the file whose address range covers the request, and reads that file. Article
requests fan out to the article file plus its Section files — readable in parallel. Sub-section
and clause requests read the single covering Section file and locate the unit inside its
verbatim body. An address the manifest doesn't cover, or a clause the covering file doesn't
contain, is not-found — there is no fuzzy fallback anywhere in the flow.

**Context loading strategy**: consumers never load the whole corpus. The manifest is the only
always-read artifact; unit files are read individually and on demand, which is what makes
Section-level splitting the token-thrift mechanism the corpus exists to provide.

---

## Architecture Decisions

### ADR-1: Store the Constitution as one file per Section

**Context**: The spec requires units retrievable in isolation and in parallel, down to clause
granularity, without loading the whole document. The developer directed a multi-file split;
the grain was open. (Resolve-phase decision.)

**Options considered**:
1. **One file per Section (`N.M`)** — ~50 files of ~1–3k tokens. Natural self-contained
   reading unit; every finer address (sub-section, clause) resolves inside one small file.
2. **One file per Article** — ~7 files, but each 10–15k characters, defeating the token-saving
   purpose of fine-grained citation retrieval.
3. **One file per sub-section (`N.M.K`)** — smallest reads, but hundreds of files, and clauses
   ripped from the sub-section siblings that give them meaning.

**Decision**: Option 1 — one file per Section. The Preamble, each Article's heading/lead-in,
and the license attribution get their own files since they sit outside the `N.M` grid.

In practice: retrieving `1.1` reads one file; retrieving `5.3.5(a)` reads `5.3.md` and locates
clause (a) within sub-section 5.3.5; retrieving `Article 2` reads `article-2.md` plus every
`2.*.md` in parallel.

**Consequences**: Clause-level requests pay for their full Section (~1–3k tokens) — an accepted
tradeoff for coherent context and a manageable file count. File names double as address
prefixes, so the storage convention reinforces the addressing scheme rather than hiding it.

### ADR-2: Resolve addresses via a generated manifest plus naming convention — no runtime lookup code

**Context**: The spec's anti-fabrication floor demands deterministic not-found behavior.
PROJECT.md constrains the plugin to remain free of runtime coupling and to serve both
conversational and programmatic consumers. (Resolve-phase decision.)

**Options considered**:
1. **Manifest + convention** — a generated index lists every retrievable file with its address
   range and metadata; consumers look up, then read files directly. Not-found = absent from
   manifest. No executable in the retrieval path.
2. **Lookup script (CLI)** — mechanically stronger guarantee, but injects a runtime executable
   into an otherwise pure text-and-skills plugin, and forces every consumer to shell out.

**Decision**: Option 1 — manifest + convention. The manifest is written as a strict markdown
table so agents read it natively and programmatic consumers parse it deterministically.

**Consequences**: The not-found guarantee is only as good as the manifest, so the manifest is
exclusively generated by the capture script — never hand-edited (see Cross-cutting Concerns).
No runtime dependency is added; Shared Constitution Access (spec 003) can distribute the skill
as plain files.

### ADR-3: Manifest indexes files, not clauses — finer addresses resolve inside the covering file

**Context**: Enumerating every sub-section and clause in the manifest (~600+ rows) would make
the always-read index cost more than the unit files it points at, inverting the token budget.

**Options considered**:
1. **File-level manifest** — one row per unit file (~60 rows) with its covered address range;
   sub-section/clause existence is settled by the covering file's verbatim body.
2. **Exhaustive address manifest** — every address gets a row; not-found is fully settled at
   the index, but the manifest balloons to the size of a small corpus.

**Decision**: Option 1 — file-level manifest. Not-found remains deterministic in two steps:
no covering file in the manifest → not found; covering file read but the unit absent from its
byte-exact body → not found.

**Consequences**: The manifest stays cheap enough to read on every retrieval. Clause-level
not-found requires one file read — acceptable, since the file is small and the read also
serves the successful case.

### ADR-4: Verbatim bodies with additive frontmatter, proven by capture-time round-trip reassembly

**Context**: The spec demands character-for-character fidelity, yet each unit must carry
metadata (address, heading, parent chain, version, source anchor). Metadata embedded *in* the
text would break byte-exactness.

**Options considered**:
1. **Frontmatter + verbatim body** — metadata lives in a frontmatter block; everything below
   it is untouched source text, headings included. Fidelity is provable: strip frontmatter,
   concatenate bodies in document order, byte-compare with the pinned source.
2. **Sidecar metadata files** — bodies stay pristine but every unit becomes two files, doubling
   the corpus and splitting each retrieval into two reads.

**Decision**: Option 1 — frontmatter + verbatim body, with the round-trip byte-comparison built
into the capture script as a blocking step. The reassembly check is also the spec's own
validation scenario, automated.

**Consequences**: One read yields text plus metadata. The strict "body is source text"
discipline must hold forever — any hand-edit to a body breaks fidelity silently, which is why
regeneration-only is a hard rule (Cross-cutting Concerns).

### ADR-5: Corpus, manifest, and capture script all live inside the single `constitution` owner skill

**Context**: The feature model mandates single-skill ownership; the open question was whether
the corpus sits inside the skill or in a top-level data directory the skill points at.

**Options considered**:
1. **Everything inside `skills/constitution/`** — the skill *is* the source of truth; spec 003
   distributes by making this one directory reachable (owner-skill-plus-symlink).
2. **Top-level `data/constitution/` + thin skill** — separates data from instruction, but
   creates two things to own and lets consumers bypass the skill's addressing rules.

**Decision**: Option 1 — single directory, single owner. SKILL.md, manifest, units, and capture
script travel as one unit.

**Consequences**: Spec 003's symlink mechanism gets exactly one target. Consumers who follow
SKILL.md inherit the not-found discipline; the layout offers no sanctioned side door.

---

## Cross-cutting Concerns

**Error handling**: There is one failure surface at runtime — not-found — and it is behavioral,
not exceptional: SKILL.md instructs consumers to report the address as unresolvable and never
substitute nearby text. At capture time the posture inverts: any anomaly (fetch failure, split
ambiguity, round-trip mismatch) aborts the whole capture with a diagnostic; a partial corpus is
never written.

**Regeneration-only discipline**: manifest.md and everything under `units/` are generated
artifacts. The only sanctioned mutation path is re-running the capture script against a pinned
commit. This single rule protects both fidelity (ADR-4) and the not-found guarantee (ADR-2).

**Testing strategy**: the capture script's round-trip byte-comparison is the fidelity test and
runs on every capture. Beyond it, a small fixed set of address-resolution checks (a Section, a
clause, the Preamble, the license, a known-bad address) exercises the manifest → file → unit
flow end to end. The scenarios skill will derive these from the spec's driving scenarios.

**Configuration**: three pinned inputs — the upstream commit SHA, the version label `5.0`, and
the source URL — serve as the capture script's defaults and are recorded in the manifest header
(alongside the capture date). The version, commit, and source URL are echoed into every unit's
frontmatter. Nothing else is configurable.

---

## Implementation Strategy

**Phase 1 — Capture tooling and corpus**: build the capture script (fetch pinned commit, split
on the document's own heading structure, emit frontmattered unit files, generate manifest,
round-trip verify); run it to produce the committed corpus. The script is a standalone,
dev-time tool with no third-party dependencies; exact language is the Builder's choice within
that constraint. Deliverable: `references/manifest.md` + `references/units/*` passing the
byte-comparison, with commit SHA and version recorded.

**Phase 2 — Owner skill surface** (depends on Phase 1): write `skills/constitution/SKILL.md`
documenting the addressing grammar (Preamble, `Article N`, `N.M`, `N.M.K`, `N.M.K(a)`,
license), the manifest-first lookup procedure, the parallel-read pattern for Articles, and the
not-found rule. Validate against the fixed address-resolution checks.

Two phases, one dependency edge. No further sequencing exists to invent.

---

## Risks

**1. The real document resists clean splitting** (likelihood: medium, impact: medium). Lead-in
prose under Article headings, inconsistent clause formatting, or structural quirks not visible
in the fetched overview could complicate boundary detection. *Mitigation*: the split derives
from the document's own headings, the round-trip check makes any text loss impossible to miss,
and the generated manifest is human-reviewed once at first capture.

**2. The pinned commit is not actually version 5.0** (likelihood: low, impact: high). The spec
carries this as its one `[ASSUMED]` item — master may drift past 5.0. *Mitigation*: confirm
the chosen SHA corresponds to the 5.0 release (tag or holacracy.org cross-check) before first
capture; record the SHA so the claim stays auditable.

**3. Silent corpus drift after capture** (likelihood: low, impact: high). A well-meaning
hand-edit to a unit file breaks byte-exactness invisibly. *Mitigation*: the regeneration-only
rule, plus re-running the capture script's verification as a repo check once CI exists —
worth revisiting when the project gains automation.

---

## What This Plan Does Not Cover

- **Structural contracts** — the manifest's exact column set, the frontmatter field schema, and
  the SKILL.md consumer contract are the interface skill's deliverable (this feature is a
  specification boundary: it produces a skill plus declarative artifacts for agent consumption).
- **Executable scenarios** — the scenarios skill derives Gherkin from the spec's driving
  scenarios against this architecture.
- **Task decomposition** — the tasks skill splits the two phases into PR-sized units.
- **Citation checking and distribution** — deliberately excluded per the spec's non-behaviors;
  they are specs 002 and 003.
