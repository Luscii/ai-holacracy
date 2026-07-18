# Holacracy — Issue Tree

Problems this plugin exists to resolve, decomposed into sub-problems. Solutions are retained as non-binding candidate notes (`+ candidate:`), never committed here — committed solutions live in FEATURE-MODEL.md, owned by Score. Bootstrapped from the `/prelude:explore` session of 2026-07-18 (see EXPLORE-LOG.md).

> How do we help a member of a Holacracy organization produce high-quality governance and find their footing in the method?

---

* Low-Quality Governance Artifacts — Members produce weak governance: uninspiring purposes, freedom-stripping accountabilities, and roles with overlapping or unclear boundaries. Sits fully inside the Editor's scope.
  + affects: Member
  + affects: Role filler
  * Uninspiring or Unclear Purposes — Purposes that fail to inspire, motivate, or clarify a role's reason to exist. Already addressed by the existing role-purpose skill.
    + candidate: role-purpose skill — Existing skill that raises purpose quality; absorb it into the Editor rather than leaving it standalone.
  * Over-prescribing Accountabilities — Accountabilities that dictate how the work is done and strip away the role-filler's freedom. Already addressed by the existing role-accountability skill.
    + candidate: role-accountability skill — Existing skill that raises accountability quality; absorb it into the Editor rather than leaving it standalone.
  * Role Boundaries and Worthiness — Roles overlap or have fuzzy edges, and it is unclear whether something warrants a role at all or is just an accountability.
    + related-to: Domain Quality and Warrant
  * Change-set Coherence — Individually-good artifacts can still compose an incoherent role or change-set; the whole must hang together, not just each piece. This is the problem behind wanting the per-artifact skills to work together.
  * Policy Quality — Policies that are unclear, over-reaching, or poorly scoped to the domain they govern.
  * Domain Quality and Warrant — Two jobs: drawing a good domain when one is warranted, and judging whether a domain is warranted at all versus leaving freedom. Design tension to respect: pushing for more or better domains cuts against the freedom leadership values, and over-specifying domains is itself a recognized anti-pattern.
    + related-to: Role Boundaries and Worthiness

* Newcomer Footing — Newcomers to a Holacracy organization can't get their footing in the method. Decomposed by underlying cause. Sits in the Coach's scope.
  + affects: Newcomer
  * Method Literacy — Knowledge gap: not understanding what the method's constructs are or how the method works.
  * Practice Fluency — Applying the known method to a live, real situation; theory is not the same as practice. Cross-cuts Method Literacy.
    + related-to: Method Literacy
  * Change Agency — Mindset, not knowledge: believing the org is yours to change. People from traditional orgs arrive assuming they must adapt to the org rather than reshape it.
  * Tension Articulation — Turning a raw feeling into a nameable tension: what a tension even is, whether this is one, and how to name it. The loop's input. Constraint to respect: CONSTITUTION.md Principle V — the plugin may sharpen a felt tension but must never manufacture one.

* Unadjudicated Constitutionality — The practitioner can't get a grounded verdict on whether something is constitutional. The Judge interprets the Constitution and issues a citable verdict — "what does the Constitution mean for my case?" Human analogue: the Secretary. The umbrella question "does this violate the Constitution?" is the parent; the sub-problems below are its flavors.
  + affects: Member
  * Validity of Proposed Governance — "Is this well-formed or valid?" A verdict on the Editor's output.
    + related-to: Change-set Coherence
  * Permissibility of Action — "Is this behavior allowed? Can I change this?"
  * Role Scope and Duties — "Am I responsible for this? What must I share? What other duties do I have?"
  * Authority Interpretation and Limits — "What constrains my authority? How should I interpret Authority?"

* Ungrounded or Unresolvable Constitution — Foundational problem: the plugin has no single, machine-resolvable source-of-truth Constitution to ground teaching, authoring, and verdicts in, so citations can't be checked and rulings risk resting on invented text (CONSTITUTION.md Principle IV; the machine-checkable-text constraint). Underlies the other three top-level problems.
  + affects: Member
  + affects: AI agent
  + candidate: Constitution-as-shared-reference — The Judge, or a dedicated Constitution skill, owns the Constitution file; Coach and Editor symlink to it. Voiced solution, retained — not committed.
  + related-to: Low-Quality Governance Artifacts
  + related-to: Newcomer Footing
  + related-to: Unadjudicated Constitutionality
