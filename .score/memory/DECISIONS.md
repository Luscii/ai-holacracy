# Decisions

Architectural precedent from the specification pipeline. Each entry records a decision that future specs should follow or explicitly diverge from. Managed by the plan skill via memory-protocol.md.

---

- Manifest-plus-convention retrieval, no runtime lookup code (from 001-canonical-constitution-text, 2026-07-18)
  Addresses resolve via a generated markdown-table manifest and file-naming convention; not-found is deterministic. Applies to any capability that reads the Constitution corpus (002, 003) and generally keeps executables out of the plugin's runtime paths.

- Verbatim body plus additive frontmatter, regeneration-only (from 001-canonical-constitution-text, 2026-07-18)
  Generated artifacts carry metadata in frontmatter above an untouched source body; fidelity is proven by capture-time round-trip byte-comparison, and generated files are never hand-edited. Applies to any future captured/verbatim corpus.

- Owner skill holds its data, docs, and tooling in one directory (from 001-canonical-constitution-text, 2026-07-18)
  Single-skill ownership means SKILL.md, declarative artifacts, and dev-time scripts travel as one unit under skills/<name>/ — giving distribution mechanisms (003) exactly one target and consumers no sanctioned side door.
