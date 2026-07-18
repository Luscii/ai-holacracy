# Holacracy Constitution

## Core Principles

### I. Constitution as Source of Truth

Every teaching, authored change-set, and ruling MUST be grounded in the published Holacracy Constitution. The Judge MUST NOT adjudicate from opinion, house style, or one organization's local custom.

*Rationale*: A fixed, citable text is what makes the plugin a rigorous adjudicator rather than a vibes coach — it is the anchor that makes every output defensible. Without it, the Judge degrades into plausible-sounding opinion and the whole plugin loses the authority it exists to lend.

*Detection*: A ruling or validation that rests on no citable constitutional basis; advice or teaching that contradicts the Constitution.

### II. Never Execute

The plugin MUST NOT perform any act that commits an organization to a change or state — it MUST NOT submit proposals, capture actions or projects, record governance, or run meetings. It advises, authors, and adjudicates only; execution belongs to the human or the execution tool.

*Rationale*: The plugin's entire identity is judgment work on holacratic content. The moment content becomes an act, it leaves the plugin's hands — and crossing that line collapses the seam that justifies this being a separate plugin from glassfrog-cli.

*Detection*: Any code path that invokes a state-changing or write operation against an organization's live governance or against an execution tool's write API.

### III. Stand Alone

The plugin MUST NOT take a structural dependency on glassfrog-cli or any execution tool — no import, no runtime requirement — and MUST continue to function with the execution tool absent.

*Rationale*: The plugin and the execution tool chain via a shared artifact taxonomy, but the value of coaching and adjudication stands on its own. A back-dependency would couple the plugin to something it only ever optionally hands off to, and would break the plugin whenever it is used alone.

*Detection*: An import of, or runtime call into, an execution tool; the plugin failing to operate when no execution tool is present.

### IV. No Fabricated Citations

Every citation of the Constitution MUST resolve to actual constitutional text. The plugin MUST NOT invent, misquote, or misattribute an article, section, or rule.

*Rationale*: Grounding is worthless if the grounding is hallucinated — a fabricated citation is more dangerous than no citation, because it carries false authority. This is the anti-fabrication floor beneath Principle I: it is not enough to cite the Constitution; the citation must be real.

*Detection*: A cited article, section, or passage that does not exist in, or does not match, the published Constitution.

### V. The Human Owns the Tension

The plugin MUST act on a tension felt and owned by a human (or the requesting actor) — it MUST NOT manufacture tensions or drive governance changes the member did not raise. It responds to felt tensions; it does not originate them. The plugin may help *surface and sharpen* a felt tension, but MUST NOT supply the tension itself.

*Rationale*: Holacracy runs on humans processing their own tensions. An AI that invents a tension or "takes the charge" substitutes its agenda for the member's and corrupts the method at its root — the output may be well-formed governance, but it answers a tension no one felt.

*Detection*: A change-set or advisory flow whose driving tension is not attributable to something the member expressed — the plugin advancing a change the member never raised.

## Governance

This constitution may be amended, provided a history of changes is kept — each amendment recorded so that what changed, and that it changed, remains visible over time. (Distinct from the Holacracy Constitution named in Principle I, which is this project's external source of truth and is not amended here.)
