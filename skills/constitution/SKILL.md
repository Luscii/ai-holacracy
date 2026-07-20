---
name: constitution
description: Use this skill whenever you need the exact, verbatim text of the Holacracy Constitution 5.0 — to ground teaching, author governance, or adjudicate a ruling, and above all to check that a claimed citation resolves to real constitutional text. Covers the six address forms (Preamble, Article N, N.M, N.M.K, N.M.K(a), License), the manifest-first lookup procedure, the parallel-read pattern for Articles, and the deterministic not-found rule that forbids substituting nearby text. Trigger when resolving or quoting a constitutional citation, retrieving a Section/Article/clause by address, verifying that an address exists, or confirming a passage is byte-exact to the published Constitution.
---

# Holacracy Constitution — Canonical Text

This skill owns the canonical, machine-resolvable text of the **Holacracy
Constitution 5.0**. It exists so that every citation, quotation, and ruling
rests on the *real* published passage — never on invented, misquoted, or
approximated text.

The corpus is a set of verbatim **unit files** under `references/units/`, indexed
by a single generated **manifest** at `references/manifest.md`. You retrieve a
passage by resolving its **address** through the manifest, then reading the one
unit file that covers it. There is no fuzzy matching anywhere in this flow: an
address either resolves to real text or it is reported as **not found**.

**Never** quote, paraphrase, or cite the Constitution from memory. If the text
you need is not retrieved through the procedure below, you do not have it.

---

## Addressing Grammar

Every retrievable passage has a canonical **address**. These are the only six
forms — anything else is malformed (see Not-Found Rule):

| Form | Example | Names |
|---|---|---|
| `Preamble` | `Preamble` | The unnumbered Preamble (and the document title above it) |
| `Article N` | `Article 2` | A whole Article (N = 1–5), including its nested Sections |
| `N.M` | `1.1` | A Section |
| `N.M.K` | `5.3.5` | A sub-section within a Section |
| `N.M.K(a)` | `5.3.5(a)` | A lettered clause within a sub-section |
| `License` | `License` | The Creative Commons attribution |

**Naming rule** — a unit file's basename *is* its address prefix. `5.3.md` covers
`5.3`, every sub-section `5.3.K`, and every clause `5.3.K(a)` present in its body.
`article-2.md` covers `Article 2` jointly with all `2.*.md` files. You never need
to know these paths in advance — the manifest maps address to file.

---

## Lookup Procedure

The manifest is the only always-read artifact. Resolve every address the same way:

1. **Read `references/manifest.md`** first. Its index table maps each covered
   address (the *Address prefix* column) to its unit file (the *File* column),
   plus that unit's *Heading* and *Parent*.
2. **Find the covering row.** Match the requested address to the row whose
   Address prefix covers it:
   - `Preamble`, `Article N`, `N.M`, and `License` match a row's Address prefix
     directly.
   - `N.M.K` and `N.M.K(a)` are covered by the `N.M` row (the Section file holds
     all its sub-sections and clauses).
   - If no row covers the address → **not found** (see Not-Found Rule). Stop.
3. **Read the unit file** named in the covering row's File column (a path relative
   to `references/`, e.g. `units/1.1.md`). Each unit opens with a YAML
   frontmatter block, then the byte-verbatim body (headings included).
4. **Locate the unit inside the body:**
   - `N.M` — the whole body is the Section.
   - `N.M.K` — find the sub-section (its `#### N.M.K …` heading) within the body
     and read through to the next sub-section heading.
   - `N.M.K(a)` — within that sub-section, find the lettered clause (e.g. the
     `- **(a) …**` item). If the sub-section or clause is **absent** from the
     body → **not found** (the byte-exact body is the final authority).
   - `Article N` — see Parallel Read Pattern below.
5. **Report** the passage's verbatim text together with its metadata from the
   frontmatter: `address`, `heading`, `parent`, `version`, `source_commit`,
   `source_url`. For `N.M.K` / `N.M.K(a)`, report the full requested address with
   its parent Section and Article (derived from the covering unit's `parent` and
   `heading`). Add the manifest header facts (version, source URL, source commit,
   captured date) wherever the consumer needs capture provenance.

**Metadata boundary** — report only the six frontmatter fields as a unit's
metadata. Never surface a file path or any storage-layout detail as part of what
a citation carries: the manifest is the single place where addresses meet
storage, and consumers cite constitutional identity and provenance, not file
locations.

---

## Parallel Read Pattern

Retrieving `Article N` is a fan-out, not a single read:

1. The covering set is `units/article-N.md` **plus every `units/N.*.md`** file
   (its Sections), all named in the manifest.
2. Read them **in parallel** — they are independent files.
3. Concatenate their bodies **in manifest (document) order** — `article-N.md`
   first, then `N.1`, `N.2`, … — to form the full verbatim text of the Article.

`article-N.md` holds the Article heading and any lead-in prose before its first
Section; the `N.*.md` files hold the Sections. Together they are the whole Article.

---

## Not-Found Rule

Not-found is a deterministic behavior, not an error to paper over. It is a
consumer obligation: when a lookup does not resolve, report it plainly and
**never substitute nearby, similar, or best-guess text**. Four conditions, in
two steps:

| Condition | Behavior |
|---|---|
| The address matches no manifest row | **Not found.** Report the address as unresolvable. Do not return approximate or nearest-match text. |
| The covering file is read, but the requested sub-section or clause is absent from its body | **Not found.** The byte-exact body is the final authority on whether a unit exists. |
| The address is malformed — not one of the six grammar forms (e.g. `"section one point one"`) | **Not found.** Do not best-guess or parse it into a valid address. |
| `references/manifest.md` is missing or malformed | **Corpus unavailable.** Report that no address can be resolved. Never fall back to guessing an address from unit file names. |

The first three are per-address not-founds; the fourth degrades the whole corpus.
In every case the honest report — "this does not resolve" — is the correct output.
A fabricated citation is worse than an admitted gap.

---

## Regeneration

`references/manifest.md` and everything under `references/units/` are **generated
artifacts**. The only sanctioned way to change them is to re-run the capture tool:

```
skills/constitution/scripts/capture [--commit <sha>] [--version <label>] [--source-url <url>]
```

Run with no flags to reproduce the pinned Constitution 5.0 corpus; the script
fetches the source at the pinned commit, splits it, and writes `references/` only
after a full round-trip byte-comparison proves the split is faithful.

**Regeneration-only rule — never hand-edit a unit body or the manifest.** A unit
body is verbatim source text; any manual edit breaks byte-exactness silently and
destroys the fidelity guarantee this skill exists to provide. Fix problems by
correcting the capture script and re-capturing, never by touching the outputs.
