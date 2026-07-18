# Holacracy — Vision & Constraints

---

## Identity

Holacracy is a Claude Code plugin that helps a member of a Holacracy-run organization do the *thinking* work of the method: understanding how the system operates, turning a felt tension into a well-shaped governance change, and telling whether something is constitutional. It meets a member wherever they are in the tension-to-resolution loop and carries them toward a clear, defensible outcome — without ever taking the action itself.

The plugin is organized around three agents that mirror the three ways a member gets stuck. The **Coach** answers "I don't understand the method" and "I have a tension — what do I do with it?" The **Editor** takes a tension bound for governance and composes the coherent, minimal change-set that resolves it — policies, roles, purposes, accountabilities, domains. The **Judge** adjudicates constitutionality, both of proposed text (is this a valid, well-formed change?) and of live behavior (is the Lead Link actually allowed to do that?). These three nodes are threaded by a single loop: the Coach clarifies a tension, the Editor shapes it, the Judge validates it, and the Coach explains the ruling.

The stance that defines the whole plugin is **advise · author · adjudicate — never execute.** Everything the plugin does is judgment work on holacratic content. The moment content becomes an *act* — submitting the proposal, capturing the action, running the meeting — it leaves the plugin's hands and returns to the human or to a separate execution tool.

This is a new project rather than an addition to the existing glassfrog-cli plugin, and the separation is not a preference — it is forced. glassfrog-cli's own vision and scope explicitly exclude coaching, interpreting tensions, and teaching Holacracy. Everything this plugin exists to do is what glassfrog-cli refuses to do, which makes a second plugin the only honest home for it.

---

## Audience

**Primary**: A member of a Holacracy-run organization who has hit a wall — a raw tension (or just an inkling of one), a moment of not understanding how the method works, or a governance change they can't quite shape into something valid. They are practitioners, not necessarily experts, and they need a rigorous, always-available guide in the moment the tension arises, not a training course scheduled for next quarter.

**Secondary**: People new to Holacracy who are still learning the method itself, and Holacracy trainers and coaches who use the plugin as an aid — a consistent, Constitution-grounded second opinion — rather than as a replacement for their own judgment.

**Tertiary**: Organizations standardizing their practice of Holacracy across many circles and teams, who want the same method, the same rigor, and the same source of truth applied consistently everywhere.

**AI agents (non-human consumers)**: The plugin serves autonomous agents as well as people. An AI agent may leverage the plugin on someone's behalf — to draft a change-set, check constitutionality, or understand the method — which is why the plugin's guidance must be reachable programmatically, not only through conversation.

---

## Principles

### 1. Advise, author, adjudicate — never execute
The plugin's entire surface is judgment work: it advises on what a tension means, authors well-shaped governance, and adjudicates whether something is constitutional. Execution belongs elsewhere.

*This means*: the plugin's outputs are advice, drafted governance text, and rulings — artifacts a human (or a separate execution tool) then acts on.
*This means we won't*: submit proposals, capture actions or projects, run meetings, or take any step that commits the organization to a change.

### 2. The Constitution is the source of truth
The plugin is anchored to the published Holacracy Constitution — a fixed, citable text — exactly as glassfrog-cli is anchored to its `spec.yaml`. This is what keeps the Judge a rigorous adjudicator rather than a vibes coach, and what makes every ruling defensible.

*This means*: rulings and validations ground themselves in the Constitution and can cite the article they rest on.
*This means we won't*: adjudicate from opinion, house style, or one organization's local custom in place of the constitutional text.

### 3. Chain with the execution tool, but stand alone
The Editor's artifact taxonomy is deliberately the same taxonomy as glassfrog-cli's typed change builders: the Editor makes the *content* judgment-quality, and the CLI makes the *payload* valid. Used together, they chain. Used alone, the coaching and adjudication still stand on their own.

*This means*: the plugin produces content that a downstream execution tool can consume, and its value does not depend on any particular one being present.
*This means we won't*: take a structural dependency on glassfrog-cli or any execution tool — no import, no runtime requirement, no coupling that breaks the plugin when used by itself.

---

## Exclusions

### 1. Execution
Submitting the proposal, capturing the action or project, running the tactical or governance meeting — none of these are the plugin's job. They belong to the human or to a separate execution tool such as glassfrog-cli.

*Why it's tempting*: the plugin walks a member all the way to a finished, valid change, so taking the final step of submitting it feels like the natural next click. But that step turns judgment into an act, and it is exactly the seam that keeps this plugin distinct from the execution tools.

### 2. Replacing the Holaco / Holakeeper
This plugin is a *subset* of the human Holakeeper and Holaco roles. Those roles carry org-routing accountabilities — signalling to a central Holacracy function, guiding a member toward formal training — that point at humans and organizational processes. Those do not become plugin capabilities.

*Why it's tempting*: because the plugin covers so much of what a Holaco does day to day, it looks like it could grow to cover the rest and "be" the Holaco. But the routing accountabilities are about connecting humans to humans, and absorbing them would let scope creep toward replacing a role the plugin is only meant to assist.

### 3. Payload validity and API mechanics
The Editor makes governance *content* coherent and constitutional; it does not construct or validate the API payloads, field formats, or wire mechanics needed to actually record a change in a tool. That is the execution tool's job.

*Why it's tempting*: the Editor's artifact taxonomy mirrors the execution tool's typed change builders one-to-one, so it looks like the plugin could just as easily emit the final payload. But content judgment and payload validity are two different quality bars, owned by two different tools by design.

---

## Constraints

**Source of truth is the published Holacracy Constitution**: The plugin must ground its teaching, authoring, and adjudication in the published Constitution as a fixed, citable text. This is the anchor that separates a rigorous adjudicator from a plausible-sounding one, and it is non-negotiable for the Judge in particular.

**One-directional relationship with the execution tool**: The plugin may produce content that glassfrog-cli (or a similar execution tool) consumes, and it deliberately shares that tool's artifact taxonomy — but the dependency must run one way only. The plugin must not import, require at runtime, or structurally couple to any execution tool. Remove the execution tool and the plugin still works.

**Separate plugin from glassfrog-cli**: This capability cannot live inside glassfrog-cli. glassfrog-cli's own vision and scope explicitly forbid coaching, interpreting tensions, and teaching Holacracy — the whole of this plugin's remit. The separation is forced by that boundary, not chosen for convenience, and collapsing the two would violate glassfrog-cli's stated scope.

---

## Success Criteria

1. **A new member of a Holacracy organization becomes effective within it faster.** Someone who just joined can use the plugin to understand how to work within the system and reach competence sooner than they would by absorbing the method through meetings and osmosis alone.

2. **A member with a raw tension — or just an inkling of one — reaches a well-formed, Constitution-valid change-set without a human coach.** The path from felt tension to submittable governance change is walkable end to end using only the plugin, and the resulting change-set survives constitutional scrutiny.

3. **Every ruling the Judge makes is grounded in the Constitution.** When the plugin adjudicates constitutionality — of proposed text or of live behavior — the answer rests on and can cite the constitutional basis for it, not on opinion or local custom.

4. **The governance a member shapes through the plugin helps the organization deliver value to its customers.** The change-sets the plugin helps author move the organizational structure toward one that serves the delivery of value (Conway's law made deliberate), rather than accreting governance that serves the org chart for its own sake.
