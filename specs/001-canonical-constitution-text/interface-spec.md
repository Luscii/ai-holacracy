# Interface Accord: Canonical Constitution Text — Specification

**Feature**: 001-canonical-constitution-text
**Role**: Crafter
**Touchpoint**: Specification
**Plan reference**: The `constitution` owner-skill boundary (plan.md System Architecture; ADR-1 through ADR-5) — the skill, its declarative corpus, and its dev-time capture tool as one specification surface.

---

## Surface

### Structural layout

| Path | Required | Description |
|---|---|---|
| `skills/constitution/SKILL.md` | yes | Owner skill: the consumer-facing instructions (see Required Sections) |
| `skills/constitution/references/manifest.md` | yes | Generated index — the only artifact mapping addresses to files |
| `skills/constitution/references/units/preamble.md` | yes | Verbatim Preamble |
| `skills/constitution/references/units/article-N.md` | yes (N = 1–5) | Article N heading + any lead-in prose before its first Section |
| `skills/constitution/references/units/N.M.md` | yes (one per Section) | Section N.M verbatim, including all its sub-sections and lettered clauses |
| `skills/constitution/references/units/license.md` | yes | Verbatim Creative Commons attribution |
| `skills/constitution/scripts/capture` | yes | Dev-time capture-and-verify tool (any extension; never invoked at runtime) |

**Naming rule**: a unit file's basename is its address prefix. `5.3.md` covers addresses `5.3`, `5.3.K`, and `5.3.K(a)` for any sub-section `K` and clause letter `a` present in its body. `article-2.md` covers the address `Article 2` jointly with all `2.*.md` files.

### Manifest contract (`references/manifest.md`)

**Header block** — four capture facts, stated once:

| Field | Description |
|---|---|
| Version | The version label: `5.0` |
| Source URL | Upstream raw-markdown URL the capture fetched |
| Source commit | Pinned commit SHA the capture is byte-verified against |
| Captured | ISO 8601 date of the capture run |

**Index table** — one row per unit file, strict column set:

| Column | Description |
|---|---|
| Address prefix | The address(es) the file covers (`Preamble`, `Article 1`, `1.1`, …, `License`) |
| File | Path relative to `references/` (e.g. `units/1.1.md`) |
| Heading | The unit's own heading text, verbatim |
| Parent | Parent chain (e.g. `Article 1: Organizational Structure`; empty for top-level units) |

Rows appear in document order. The manifest contains no content excerpts — it is index, not corpus.

### Unit frontmatter contract

Every unit file opens with a YAML frontmatter block of exactly these six fields, followed by the byte-verbatim body (headings included):

| Field | Type | Description |
|---|---|---|
| `address` | string | The unit's canonical address (`1.1`, `Article 2`, `Preamble`, `License`) |
| `heading` | string | The unit's heading text, verbatim |
| `parent` | string | Parent chain; empty for top-level units |
| `version` | string | `5.0` |
| `source_commit` | string | Pinned commit SHA (same value in every unit) |
| `source_url` | string | Upstream raw-markdown URL |

**Leakage rule**: frontmatter carries constitutional identity and provenance only — never file paths or storage layout. The manifest is the single place addresses meet storage. This satisfies the spec's no-storage-leakage validation scenario.

### Capture script invocation

```
scripts/capture [--commit <sha>] [--version <label>] [--source-url <url>]
```

| Flag | Required | Default | Description |
|---|---|---|---|
| `--commit` | no | pinned SHA (built into script) | Commit to fetch and verify against |
| `--version` | no | `5.0` | Version label stamped into manifest and frontmatter |
| `--source-url` | no | pinned upstream URL | Raw-markdown source location |

Defaults are the pinned facts; flags exist for re-capture verification. Flag names are contract-shape — the Builder may rename compatibly (same three inputs, same optionality).

### SKILL.md — required sections

| Section | Structural requirement |
|---|---|
| Addressing Grammar | Defines all six address forms: `Preamble`, `Article N`, `N.M`, `N.M.K`, `N.M.K(a)`, `License` |
| Lookup Procedure | Manifest-first: read manifest → find covering row → read unit file → locate unit in body |
| Parallel Read Pattern | Article retrieval = `article-N.md` + all `N.*.md`, readable concurrently |
| Not-Found Rule | The two-step deterministic rule (see Error Communication), stated as a consumer obligation |
| Regeneration | Points to `scripts/capture`; states the regeneration-only rule (no hand-edits, ever) |

---

## Interactions

**Consumer flow (runtime, read-only)**:
1. Read `references/manifest.md` (always first; it is the only always-read artifact).
2. Resolve the requested address to its covering row via the Address-prefix column.
3. Read the unit file named in the File column.
4. For `N.M` requests: the whole body is the unit. For `N.M.K` and `N.M.K(a)`: locate the sub-section or clause inside the verbatim body. For `Article N`: read `article-N.md` plus every `N.*.md` in parallel, concatenating in manifest (document) order.
5. Report the unit's text with its frontmatter metadata (plus the manifest header facts where the consumer needs capture provenance).

**Maintainer flow (dev-time, write-only)**:
1. Run `scripts/capture` (defaults = pinned facts).
2. Script fetches the source at the commit, splits on the document's own heading structure, generates all unit files and the manifest in a staging step.
3. Script reassembles all bodies in document order and byte-compares against the fetched source.
4. Only on an exact match does the script write `references/` outputs. Re-running with unchanged inputs is idempotent — byte-identical outputs.

**Configuration**: none at runtime. The two pinned facts (commit SHA, version label) plus the source URL live as capture-script defaults and are echoed into the manifest header and every unit's frontmatter. Nothing else is configurable.

---

## Error Communication

**Runtime not-found contract** (deterministic, two-step):

| Condition | Behavior |
|---|---|
| Address matches no manifest row | Not found. Report the address as unresolvable; never substitute nearby or similar text. |
| Covering file read, but the sub-section or clause is absent from its body | Not found. Same rule — the byte-exact body is the final authority on unit existence. |
| Malformed address (not one of the six grammar forms) | Not found. No best-guess parsing. |
| `manifest.md` missing or malformed | Corpus unavailable. Consumers must report inability to resolve any address — never fall back to guessing from file names. |

**Capture-time contract**:

| Condition | Behavior |
|---|---|
| Fetch failure, split ambiguity, or round-trip byte mismatch | Abort: non-zero exit, diagnostic to stderr, zero files written. A partial corpus never exists. |
| Successful capture and verification | Exit 0; complete `references/` output set written. |

---

## Consistency Notes

- **No sibling interface files** — this feature's only touchpoint is the specification surface. The capture script is dev-time tooling folded into this accord (plan classification), not a CLI touchpoint.
- **No `accords/` directory exists yet** — this accord sets the house pattern for specification surfaces. Specs 002 (Citation Resolution & Verification) and 003 (Shared Constitution Access) should reference this file's manifest, frontmatter, and not-found contracts rather than redefining them.
- **Layout follows the established skill convention** (SKILL.md + `references/` + `scripts/`), consistent with the plugin ecosystem PROJECT.md describes and with DECISIONS.md precedent: owner skill holds its data, docs, and tooling in one directory.
