# Holacracy — Feature Model

Solutions committed for the problems in `ISSUE-TREE.md`, each decomposed into buildable capabilities. A `## <Solution Name>` section names a committed solution; its `> Problem:` field links it back to the problem it resolves. `## Shared` holds capabilities used by more than one solution. This is the bridge from the problem space (Prelude) to specification (Score) — each capability is specify-sized.

---

## Constitution Reference
> Problem: Ungrounded or Unresolvable Constitution — The plugin has no single, machine-resolvable source-of-truth Holacracy Constitution to ground teaching, authoring, and verdicts in, so citations can't be checked and rulings risk resting on invented text.

- Canonical Constitution Text — The published Holacracy Constitution captured as one machine-resolvable, citable source file, owned by a single skill and addressable at the article / section / rule granularity that citations name.

- Citation Resolution & Verification — Resolving a citation reference to the exact constitutional passage it names, and confirming a claimed citation matches real text — the anti-fabrication check behind No Fabricated Citations (Principle IV).
  + depends-on: Canonical Constitution Text

- Shared Constitution Access — Making the single canonical source reachable by all three agents (Coach, Editor, Judge) through the owner-skill-plus-symlink mechanism, so there is exactly one source of truth and no divergent copies.
  + depends-on: Canonical Constitution Text

---

## Coherent Change-set Composer
> Problem: Change-set Coherence — Individually-good artifacts can still compose an incoherent role or change-set; the whole must hang together, not just each piece. This is the problem behind wanting the per-artifact skills to work together.

- Change-set Assembly — Composing the individual governance artifacts (purposes, accountabilities, roles, policies, domains) that resolve a tension into one structured change-set, drawing on the existing per-artifact quality skills for each piece.

- Cross-artifact Coherence Check — Verifying the assembled artifacts hang together as a whole: no contradictions, no overlapping or duplicated roles and accountabilities, purposes and accountabilities aligned within each role, domains coupled to the policies that govern them, no structural gaps — catching the incoherence per-artifact quality can't see.
  + depends-on: Change-set Assembly

- Change-set Minimization — Reducing the change-set to the minimal set of amendments that resolves the tension, pruning redundant or superfluous changes so the whole is no larger than the tension requires.
  + depends-on: Change-set Assembly

- Tension Traceability — Ensuring every amendment traces back to the driving tension and that the change-set actually resolves it, so the whole answers the felt tension without drifting beyond it.
  + depends-on: Change-set Assembly
