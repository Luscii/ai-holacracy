# Holacracy — Project Domain

---

## Domain

Holacracy is a constitutional system for running an organization: authority is distributed across **roles** grouped into **circles**, and the rules of the game are fixed in the published **Holacracy Constitution**. People experience the method as a loop — someone senses a **tension** (a gap between how things are and how they could be), and the method gives them structured ways to resolve it: share or capture information, take an action or project themselves, ask someone else via a request, or change the organization's structure through **governance**.

This project operates one level up from that loop: it helps a person (or an AI agent) *think* their way through it. The problem space has three recurring failure points, and the plugin is organized around them as three agents. A member who can't understand the method, or can't tell what to do with a tension, is stuck on **Holacracy illiteracy** — the **Coach** answers this, teaching the method and advising across the whole tension-to-resolution space. A member who knows they need to change governance but produces a malformed or incoherent change is stuck on **ill-shaped governance** — the **Editor** answers this, composing the coherent, minimal **change-set** (touching policies, roles, purposes, accountabilities, and domains) that resolves the tension. A member who can't tell whether something is constitutional is stuck on **unadjudicated constitutionality** — the **Judge** answers this, ruling on both proposed governance text and live behavior.

The three agents are threaded by the same loop they serve: the Coach clarifies a tension, the Editor shapes it into governance, the Judge validates it, and the Coach explains the ruling. The whole plugin sits behind a single boundary — **advise · author · adjudicate, never execute** — so the domain it deals in is holacratic *content and judgment*, never the act of recording or enacting a change. Recording and enacting belong to a separate **execution tool** (glassfrog-cli), whose typed change builders consume the same artifact taxonomy the Editor produces.

---

## Vocabulary

Holacracy terms are defined **as this plugin uses them** — enough to anchor specs and rulings, not to re-teach the method. The canonical source for every method term is the Constitution.

| Term | Definition | Also known as |
|---|---|---|
| Holacracy | The constitutional, role-based system of organizational governance this plugin assists with. | |
| Constitution | The published Holacracy Constitution — the fixed, citable text that is this project's source of truth for every ruling and validation. | |
| Tension | A person's sense of a gap between how things are and how they could be; the input that starts the loop. Not a synonym for "problem" or "conflict." | |
| Governance | The structural rules of a circle — its roles, policies, purposes, accountabilities, and domains — and the process of changing them. Contrasted with **Tactical**, the operational work of getting things done. | |
| Change-set | The coherent, *minimal* set of governance amendments the Editor composes to resolve one tension. The unit the Editor produces and the execution tool records. | proposal (related — a change-set becomes a proposal when submitted, which is out of scope) |
| Circle | An organizational unit containing roles and its own governance; the context every change-set lives within and every ruling is made relative to. | |
| Role | A named container of authority — a purpose, accountabilities, and domains — that a member energizes. The Editor decides role-worthiness ("a role, or just an accountability?") and handles create/remove/rename plus coherence. | |
| Policy | A circle-level grant or constraint on how roles may act, often governing access to a domain. | |
| Purpose | The reason a role or circle exists — its heart/why. (Owned by an existing Editor sub-skill.) | |
| Accountability | An ongoing activity a role performs, expressed in -ing-verb form — a role's hands/how. (Owned by an existing Editor sub-skill.) | |
| Domain | Something under a role's or circle's exclusive control, that others may not impact without permission. Coupled with Policy (policies grant/limit access to domains). *In this project "Domain" always means this Holacracy sense — never the problem domain or a document section.* | |
| Valid objection / Well-formedness | The constitutional tests the Judge applies to proposed governance text — whether an objection is valid, and whether a change is structurally well-formed. | |
| Coach / Editor / Judge | The plugin's three agents (advise / author / adjudicate). Internal components of the system, not external actors. | |
| Execution tool | glassfrog-cli — the separate plugin that performs the execution this plugin refuses to: submitting proposals, capturing actions, recording governance. | |
| Holaco / Holakeeper | The human roles that steward Holacracy in an organization. This plugin is a *subset* of them; their org-routing-to-humans accountabilities are out of scope. | |

---

## Actors

**Member**: A person in a Holacracy-run organization — the primary user. Arrives with a tension, a method question, or a governance change they can't shape, and uses the plugin to think it through.

**Role filler**: A member *energizing a specific role* — acting under that role's purpose, accountabilities, domains, and authority. Distinct from Member: the Member is the human; the Role filler is that human exercising a role. Facilitator, Circle Rep, and Circle Lead are role fillers captured through **Role** and **Accountability**, not as separate actors — their special status flows from the Constitution and their role definitions, not from this project.

**Secretary**: The role whose constitutional-interpretation and validity-ruling authority is the human analogue of the **Judge**. The Secretary is *wider* — it records governance, interprets it, and rules on process — and the Judge assists only a subset of what it does. Called out separately because that overlap warrants special attention when shaping the Judge.

**Circle**: The organizational unit and the context a change-set is composed for and a ruling is made relative to. Not a person, but an actor in the sense that its current governance is the state the Editor reasons about and the Judge measures against.

**Trainer / Coach**: A human Holacracy expert who uses the plugin as an aid — a consistent, Constitution-grounded second opinion — rather than as a replacement for their own judgment.

**AI agent**: An autonomous agent (not a human) that leverages the plugin to perform holacratic work on someone's behalf — drafting a change-set, checking constitutionality, or understanding the method. A first-class consumer alongside human users, which means the plugin's outputs must be usable programmatically, not only conversationally.

**Execution tool**: glassfrog-cli — an invisible/system actor that consumes the Editor's change-sets and performs the execution the plugin itself never does.

---

## Scope

### In Scope
- **The Coach** — teaching the method (timeless, concept-level) and advising a member across the whole tension-to-resolution space; the governance branch hands off to the Editor.
- **The Editor** — composing the coherent, minimal governance change-set for a tension: policies, roles (including role-worthiness and create/remove/rename), purposes, accountabilities, and domains. Absorbs restructuring.
- **The Judge** — adjudicating constitutionality of both proposed governance text (valid-objection / well-formedness, verifying the Editor's output) and live behavior (authority disputes — "is the Lead Link allowed to do that?").
- **Constitution-grounded rulings** — every adjudication rests on and can cite the constitutional basis for it.
- **Programmatic and conversational use** — outputs consumable by both a human member and an AI agent.

### Out of Scope
- **Execution** — submitting proposals, capturing actions or projects, running meetings. This is the plugin's defining boundary; execution belongs to the human or the execution tool.
- **Payload and API mechanics** — constructing or validating the wire-level payloads, field formats, and API calls needed to record a change. The Editor makes content judgment-quality; the execution tool makes the payload valid.
- **Org-routing-to-humans (replacing the Holaco/Holakeeper)** — signalling to a central Holacracy function, guiding a member toward formal training. These accountabilities connect humans to humans and stay with the human roles.

### Deferred
- **Splitting the Coach's "process my tension" into its own agent** — the Coach carries two jobs (teach the method / process a tension). Deferred as a decomposition of the Coach, not a sequencing decision. Re-inclusion condition: the tension-processing competency grows complex enough that sharing the Coach's context measurably hurts it.

*Build order across the three agents is deliberately not fixed here — sequencing belongs to `/prelude:roadmap` and Score's prioritization, driven by issues and impact on members/operators. All three agents are In Scope.*

---

## Constraints

**Source of truth is the published Holacracy Constitution**: Every teaching, authored change-set, and ruling must ground itself in the published Constitution as a fixed, citable text — the same role `spec.yaml` plays for the execution tool. This is what separates a rigorous adjudicator from a plausible-sounding one, and it is non-negotiable for the Judge in particular.

**The Constitution must be present as machine-checkable text**: The published Holacracy Constitution must be available to the plugin as a citable, machine-resolvable text — one the plugin can look a citation up in and confirm it matches actual constitutional passages. This flows from the No Fabricated Citations principle: without a resolvable source text to check against, the plugin cannot guarantee its citations are real.

**One-directional relationship with the execution tool**: The Editor's artifact taxonomy is deliberately the same as the execution tool's typed change builders, so their outputs chain. But the dependency runs one way only — this plugin must not import, require at runtime, or structurally couple to glassfrog-cli or any execution tool. Remove the execution tool and the plugin still works.

**Separate plugin, forced by glassfrog-cli's own boundary**: This capability cannot live inside glassfrog-cli, whose vision and scope explicitly forbid coaching, interpreting tensions, and teaching Holacracy — the whole of this plugin's remit. The separation is structural, not a matter of convenience.

**Outputs must serve both human and AI-agent consumers**: Because an AI agent is a first-class actor, the plugin's advice, change-sets, and rulings have to be consumable programmatically, not only as prose in a conversation. This bounds how outputs can be shaped.
