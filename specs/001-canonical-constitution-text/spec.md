# Specification: Canonical Constitution Text

**Feature**: 001-canonical-constitution-text
**Role**: Definer
**Tier**: 1 (zero setup)

---

## System Overview

The Holacracy plugin's Coach, Editor, and Judge agents all reason about the Holacracy
Constitution — teaching it, authoring against it, and issuing verdicts under it. Today there
is no single machine-resolvable source of that text, so citations cannot be checked and
rulings risk resting on invented passages. This capability captures the published Holacracy
Constitution (version 5.0) as one citable source of truth, addressable at the granularity a
citation names — Article, Section, and rule — and retrievable one unit at a time.

It is the foundation of the Constitution Reference solution: Citation Resolution & Verification
and Shared Constitution Access both build directly on the addressable, byte-exact source this
capability provides. It does not check citations or distribute the source — it only *holds the
authoritative text and makes it addressable*.

---

## Behavioral Accord

### Capture & fidelity

- When the source is captured, it reproduces the published Holacracy Constitution text
  exactly — character-for-character, including punctuation, casing, and cross-reference
  wording as written.
- When a captured unit is compared against the published source at the same address, the two
  match exactly with no normalization, summarization, or paraphrase.
- When the trailing Creative Commons license attribution is captured, it is preserved verbatim
  as an addressable unit.

### Addressing

- When a citation names an address, the corresponding unit is identifiable in the source at
  Article, Section (`N.M`), sub-section (`N.M.K`), and lettered-clause granularity.
- When a lettered clause is cited, it is addressed by appending the clause letter in
  parentheses to its sub-section address, mirroring the Constitution's own inline rendering —
  e.g. `5.3.5(a)`.
- The addressable units are: the Preamble, each Article (1–5), each Section (`N.M`), each
  sub-section (`N.M.K`), each lettered clause within a sub-section, and the license attribution.

### Retrieval

- When a valid address is requested, the source returns that unit's exact text together with
  its metadata: its full address, its heading, its parent Article/Section chain, the version,
  and a pinned source anchor (see Versioning & provenance).
- When a parent unit (an Article or a Section) is requested, the returned text includes the
  verbatim text of every unit nested beneath it.
- When a single unit is requested, it is retrievable without requiring the entire Constitution
  to be loaded — units can be read in isolation and in parallel.

### Versioning & provenance

- When the source is queried for its version, it reports **5.0**, carried as attached metadata
  pinned to the captured source commit — the published text itself does not declare a version.
- When a unit is retrieved, its metadata carries a pinned source anchor — the upstream commit
  the text was captured from, together with a source reference for the unit — so any citation
  can be re-checked against the exact published commit it came from.

### Anti-fabrication floor

- When an address that corresponds to no captured unit is requested, the source returns a
  not-found result — it never returns approximate, nearest-match, or invented text.

---

## User Scenarios

**In order to** check a claimed citation against the real constitutional passage,
**as** the Citation Resolution & Verification capability,
**I want to** retrieve the exact text a given address names.

**In order to** ground a coaching explanation in authoritative text without spending the
context budget on the whole document,
**as** the Coach agent,
**I want to** fetch a single Section in isolation.

**In order to** guarantee a ruling rests on real constitutional text,
**as** the Judge agent,
**I want** every retrieved passage to be byte-exact to the published Constitution.

---

## Non-Behaviors

- The system must not judge or verify whether a *claimed* citation matches its text. **Why**:
  that is Citation Resolution & Verification's job; merging checking into storage couples two
  capabilities and blurs the anti-fabrication boundary the reference is meant to draw.
- The system must not copy or distribute the source to the three agents. **Why**: Shared
  Constitution Access owns single-source distribution; duplicating that here risks divergent
  copies — the exact failure a single source of truth exists to prevent.
- The system must not interpret, summarize, teach, or paraphrase the Constitution. **Why**: any
  transformation of the text breaks byte-exact fidelity and re-opens the fabrication risk that
  No Fabricated Citations (Principle IV) forbids.
- The system must not auto-update when the upstream published source changes. **Why**: version
  identity (5.0) must be stable and pinned; silent drift would make prior citations
  unverifiable against a moving target.
- The system must not return approximate or nearest-match text for an unknown address. **Why**:
  a wrong-but-plausible passage is worse than none — it is fabrication wearing a citation.

---

## Integration Boundaries

- **Published Holacracy Constitution (upstream)**: read once at capture time from the
  holacracyone source, pinned to a specific commit for version 5.0. Not re-fetched at query
  time; if the upstream source is unavailable after capture, retrieval is unaffected.
- **Citation Resolution & Verification (downstream)**: reads addressable units by address to
  resolve and verify citations. Depends on this capability's addressing scheme, byte-exact
  fidelity, and pinned source anchor.
- **Shared Constitution Access (downstream)**: reads this single source to make it reachable by
  the Coach, Editor, and Judge agents through the owner-skill mechanism.

---

## Driving Scenarios

### Happy path

**Scenario: Retrieve a Section by address**
Given the Constitution 5.0 has been captured
When address `1.1` is requested
Then the exact text of "1.1 Role Definition" is returned
And the metadata reports heading "Role Definition", parent "Article 1: Organizational Structure", version 5.0, and the pinned source anchor

**Scenario: Retrieve an Article, including its nested units**
Given the Constitution 5.0 has been captured
When address `Article 2` is requested
Then the full verbatim text of "Article 2: Rules of Cooperation" is returned, including all its Sections and sub-sections

**Scenario: Retrieve a rule-grain clause**
Given the Constitution 5.0 has been captured
When address `5.3.5(a)` is requested
Then the exact text of clause (a) of sub-section 5.3.5 is returned
And the metadata reports its full address and its parent Section and Article

### Error scenarios

**Scenario: Unknown address returns nothing, never invents**
Given the Constitution 5.0 has been captured
When an address that names no captured unit (e.g. `9.9`) is requested
Then a not-found result is returned
And no approximate or nearest-match text is returned

**Scenario: Malformed address is not best-guessed**
Given the Constitution 5.0 has been captured
When a request supplies an address that is not a well-formed constitutional address
Then a not-found result is returned rather than a best-guess match

### Edge cases

**Scenario: Retrieve the unnumbered Preamble**
Given the Constitution 5.0 has been captured
When the Preamble is requested
Then its exact text is returned even though it carries no numeric address

**Scenario: Retrieve the license attribution**
Given the Constitution 5.0 has been captured
When the trailing Creative Commons license attribution is requested
Then it is returned verbatim as an addressable unit

**Scenario: Sub-section retrieval includes its lettered clauses**
Given the Constitution 5.0 has been captured
When a sub-section that contains lettered clauses is requested at its `N.M.K` address
Then the returned text includes all of that sub-section's clauses in order

---

## Validation Scenarios

> These are held out from the implementing agent for independent verification.

**Scenario: No implementation leakage in retrieved metadata**
Given a unit is retrieved with its metadata
When the metadata is inspected
Then it describes only the unit's constitutional identity and provenance (address, heading,
parent chain, version, pinned source anchor) and exposes no storage-layout or file-path detail

**Scenario: Round-trip fidelity across the whole document**
Given the full Constitution is retrieved unit by unit and reassembled in document order
When the reassembly is compared to the published source 5.0
Then it matches character-for-character with no gaps, duplications, or reordering

---

## Assumptions

- **Version label 5.0** `[ASSUMED]`: the published master document does not state a version;
  5.0 is recorded as attached metadata based on the developer's instruction and the state of
  the holacracyone master branch at capture. (If the pinned commit is a different version, this
  is wrong and user-visible.)
- **Rule grain = lettered clause**: "rule granularity" is interpreted as the lettered clause
  (`(a)`, `(b)`, …) inside a sub-section — the finest unit the published text contains.
  (Informed by the document's actual structure: headings number down to `N.M.K`; clauses are
  inline lettered lists.)
- **Parent units include their children**: retrieving an Article or Section returns the verbatim
  text of all nested units, since the published text is contiguous. (Technical default.)

---

## Ambiguity Warnings

None remaining — both original warnings were resolved during clarification (see Clarifications).

---

## Clarifications

### Session 2026-07-18

- **Clause addressing notation**: A lettered clause is cited by appending the clause letter in
  parentheses to its sub-section address (e.g. `5.3.5(a)`), mirroring the Constitution's own
  inline rendering — keeping citations recognizable to a human checker while remaining
  parseable. Resolves the addressing ambiguity for the finest "rule" grain.
- **Metadata field set**: A retrieved unit's metadata carries a pinned source anchor (the
  upstream commit the text was captured from, plus a source reference for the unit) in addition
  to address, heading, parent chain, and version — so any citation can be independently
  re-verified against the exact published commit, serving No Fabricated Citations (Principle IV).
