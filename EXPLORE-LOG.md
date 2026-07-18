# Explore Log

Session summaries from `/prelude:explore`. Each entry records what was explored, which problems and solutions looked promising or were set aside, and why. Newest sessions first.

Consumed by explore (previous session awareness) and capture (provenance detection). Owned by explore — no other skill writes to this file.

---

## Session — 2026-07-18 (Judge)

Explored the Judge side of the plugin. Reframed the Judge from a two-way adjudicator into a constitutional interpreter that issues grounded verdicts, decomposed its question space under an umbrella, and surfaced a foundational grounding problem that underlies all three agents.

### Explored
- **Unadjudicated Constitutionality** — Parent problem, Judge territory. The practitioner can't get a grounded verdict on whether something is constitutional. Reframed from PROJECT.md's narrow "proposed text + live behavior" split into a broader constitutional-interpreter framing: the Judge answers "what does the Constitution mean for my case?" This strengthens the Secretary mapping (interpreting and ruling on governance is the Secretary's constitutional authority). "Does this violate the Constitution?" was judged the umbrella (the general form of the verdict), not a fifth sibling, to avoid a MECE-breaking grab-bag. Sub-problems, each a flavor of verdict:
  - **Validity of Proposed Governance** — "is this well-formed or valid?" A verdict on the Editor's output; relates to the Editor's Change-set Coherence.
  - **Permissibility of Action** — "is this behavior allowed? can I change this?"
  - **Role Scope and Duties** — "am I responsible for this? what must I share? what other duties do I have?"
  - **Authority Interpretation and Limits** — "what constrains my authority? how should I interpret Authority?"
- **Ungrounded or Unresolvable Constitution** — Foundational problem, distinct from all three agents. The plugin has no single, machine-resolvable source-of-truth Constitution to ground teaching, authoring, and verdicts in, so citations can't be checked and rulings risk resting on invented text (CONSTITUTION.md Principle IV and the machine-checkable-text constraint). Excavated from the developer's voiced solution of hosting the Constitution in the Judge skill. Judged to underlie Low-Quality Governance Artifacts, Newcomer Footing, and Unadjudicated Constitutionality.
- **Constitution-as-shared-reference** — Voiced solution, retained as a candidate note against the foundational problem: the Judge (or a dedicated Constitution skill) owns the Constitution file and the other skills symlink to it. Not committed.

### Suggested for Capture
- **Unadjudicated Constitutionality** — Well-decomposed under an umbrella, with a clear actor (the Member, human analogue the Secretary) and a cross-link to the Editor's output. Ready to capture into the existing tree.
- **Ungrounded or Unresolvable Constitution** — Clear foundational problem with a named candidate note and dependency links to the three existing roots. Ready to capture.

### Tensions
- **Verdict versus Direction** — The load-bearing Coach/Judge distinction that emerged: the Judge issues a grounded, citable verdict; the Coach offers direction toward a solution. This line reframes "Change Agency" as Coach work and settles where duty/authority questions live (Judge, because they are citable interpretations).
- **Grounding is a prerequisite, not a sequence** — The developer's intuition that the Judge/Constitution is "the logical start" is a real dependency (recorded as `underlies`), but build order stays with `/prelude:roadmap`.

## Session — 2026-07-18

Explored the felt tension behind the whole plugin: governance quality at Luscii is weak and newcomers struggle to operate the method. Surfaced two top-level problems — one Editor-side, one Coach-side — decomposed both, and set aside cross-org inconsistency as a symptom rather than a root cause.

### Explored
- **Low-Quality Governance Artifacts** — Parent problem, Editor territory. Members produce weak governance (uninspiring purposes, freedom-stripping accountabilities, overlapping roles). Maps fully inside the Editor's scope in PROJECT.md, so no scope expansion. Decomposed by artifact type plus a coherence axis:
  - **Uninspiring or Unclear Purposes** — Already solved by the existing role-purpose skill; to be absorbed into the Editor.
  - **Over-prescribing Accountabilities** — Already solved by the existing role-accountability skill; to be absorbed into the Editor.
  - **Role Boundaries and Worthiness** — Overlap, fuzzy edges, and the "a role, or just an accountability?" judgment. Open.
  - **Change-set Coherence** — Individually-good artifacts can still compose an incoherent role or change-set. Surfaced by excavating the developer's wish to "make the skills work together." Open.
  - **Policy Quality** — Open.
  - **Domain Quality and Warrant** — Two distinct jobs: drawing a good domain when one is warranted, and judging whether a domain is warranted at all versus leaving freedom. Open.
- **Newcomer Footing** — Parent problem, Coach territory. Newcomers can't get their footing. Re-cut from presenting-complaint to underlying cause after the developer confirmed the causes were the truer spine:
  - **Method Literacy** — Knowledge gap: what the things are and how the method works.
  - **Practice Fluency** — Applying the known method to a live, real situation; theory is not the same as practice. Cross-cuts literacy.
  - **Change Agency** — Mindset, not knowledge: believing the org is yours to change. People from traditional orgs assume they must adapt to the org. A different kind of help than information.
  - **Tension Articulation** — "What is a tension, is this one, how do I name it." Kept standalone despite overlapping with Practice Fluency, because it is the loop's input and carries its own constitutional constraint.
- **Inconsistency Across Implementations** — Explored and set aside. The developer judged it a symptom of unsolved artifact quality and newcomer footing, not a root problem. Not recorded in the tree.
- **role-purpose and role-accountability skills** — Existing solutions, retained as candidate notes against the Purposes and Accountabilities sub-problems. To be integrated into the Editor rather than left standalone; not recorded as new work to build.

### Suggested for Capture
- **Low-Quality Governance Artifacts** — Well-decomposed, fully inside the Editor's scope, with two sub-problems already solved to anchor the tree. Affects the Member / Role filler. Ready to bootstrap the issue tree.
- **Newcomer Footing** — Clear underlying-cause decomposition, affects the newcomer (secondary audience). Ready to capture.

### Tensions
- **Principle V — The Human Owns the Tension** — Tension Articulation sits on the line between sharpening a felt tension (allowed) and manufacturing one (forbidden). A design constraint on that sub-problem, not a blocker.
- **Domain warrant versus freedom** — Pushing for more or better domains cuts against the freedom leadership values, and over-specifying domains is itself a recognized anti-pattern. The domain sub-problem must respect this.
- **The Coach carries two different jobs** — Informing (literacy, fluency) and emboldening (agency) are different kinds of help; relevant to build order.
- **Shared judgment shape** — Role Boundaries and Worthiness and the domain-warrant judgment are the same "does this warrant its own structural container?" call; possibly one underlying capability rather than two.
