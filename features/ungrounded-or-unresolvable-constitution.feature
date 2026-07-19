# Source: 001-canonical-constitution-text — Scenario: Retrieve a Section by address

Feature: Canonical Constitution text
  The plugin has no single, machine-resolvable source-of-truth Holacracy
  Constitution to ground teaching, authoring, and verdicts in — citations
  can't be checked and rulings risk resting on invented text.

  Rule: Check a claimed citation against the real constitutional passage
    # In order to check a claimed citation against the real constitutional passage,
    # as the Citation Resolution & Verification capability,
    # I want to retrieve the exact text a given address names.

    # Source: 001-canonical-constitution-text — Scenario: Retrieve a Section by address
    @wip
    Scenario: Section address resolves to its exact text and metadata
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "1.1" through the manifest
      Then the consumer will read the exact text of "1.1 Role Definition" from units/1.1.md
      And the frontmatter will report heading "Role Definition" and parent "Article 1: Organizational Structure"
      And the frontmatter will report version "5.0" and the pinned source commit

    # Source: 001-canonical-constitution-text — Scenario: Retrieve a rule-grain clause
    @wip
    Scenario: Lettered clause resolves inside its covering Section file
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "5.3.5(a)"
      Then the manifest will name units/5.3.md as the covering file
      And the exact text of clause (a) of sub-section 5.3.5 will be located in that file's body
      And the metadata will report the full address with its parent Section and Article

    # Source: 001-canonical-constitution-text — Scenario: Unknown address returns nothing, never invents
    @wip
    Scenario: Unknown address reports not-found
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "9.9"
      Then no manifest row will cover the address
      And the consumer will report the address as unresolvable
      And no approximate or nearest-match text will be returned

    # Source: 001-canonical-constitution-text — Scenario: Malformed address is not best-guessed
    @wip
    Scenario: Malformed address reports not-found
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves the address "section one point one"
      Then the address will match none of the six address forms
      And the consumer will report the address as unresolvable rather than best-guessing

    # Source: 001-canonical-constitution-text — Proposed: Corpus-unavailable degradation from the interface error contract
    @wip
    Scenario: Missing manifest makes the corpus unavailable
      Given the manifest file was absent or malformed
      When the consumer attempts to resolve address "1.1"
      Then the consumer will report the corpus as unavailable
      And no address will be guessed from unit file names

    # Source: 001-canonical-constitution-text — Scenario: No implementation leakage in retrieved metadata
    @validation @wip
    Scenario: Unit metadata carries no storage detail
      Given a unit had been retrieved with its frontmatter metadata
      When the metadata fields are inspected
      Then only address, heading, parent, version, source_commit, and source_url will be present
      And no file path or storage-layout field will appear

  Rule: Ground explanations without loading the whole Constitution
    # In order to ground a coaching explanation in authoritative text without
    # spending the context budget on the whole document,
    # as the Coach agent,
    # I want to fetch a single Section in isolation.

    # Source: 001-canonical-constitution-text — Scenario: Retrieve an Article, including its nested units
    @wip
    Scenario: Article retrieval assembles all nested units in order
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "Article 2"
      Then units/article-2.md and every units/2.*.md file will be identified as the covering set
      And the files will be readable in parallel
      And their bodies concatenated in manifest order will form the full verbatim text of Article 2

  Rule: Guarantee rulings rest on real constitutional text
    # In order to guarantee a ruling rests on real constitutional text,
    # as the Judge agent,
    # I want every retrieved passage to be byte-exact to the published Constitution.

    # Source: 001-canonical-constitution-text — Scenario: Retrieve the unnumbered Preamble
    @wip
    Scenario: Preamble resolves despite carrying no numeric address
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "Preamble"
      Then the manifest will name units/preamble.md as the covering file
      And its body will contain the exact published Preamble text

    # Source: 001-canonical-constitution-text — Scenario: Retrieve the license attribution
    @wip
    Scenario: License attribution is an addressable verbatim unit
      Given the Constitution 5.0 corpus had been captured
      When the consumer resolves address "License"
      Then the manifest will name units/license.md as the covering file
      And its body will contain the Creative Commons attribution verbatim

    # Source: 001-canonical-constitution-text — Scenario: Sub-section retrieval includes its lettered clauses
    @wip
    Scenario: Sub-section text includes all its clauses in order
      Given the Constitution 5.0 corpus had been captured
      And sub-section 5.3.5 contained lettered clauses
      When the consumer resolves address "5.3.5"
      Then the returned text will include every clause of 5.3.5 in document order

    # Source: 001-canonical-constitution-text — Proposed: Capture abort contract from the plan capture flow
    @wip
    Scenario: Failed round-trip verification aborts capture with no files written
      Given the capture script had fetched the source at the pinned commit
      And the reassembled split did not byte-match the fetched source
      When the capture script finishes
      Then it will exit non-zero with a diagnostic on stderr
      And no files will be written under references/

    # Source: 001-canonical-constitution-text — Scenario: Round-trip fidelity across the whole document
    @validation @wip
    Scenario: Reassembled corpus matches the published source byte-for-byte
      Given all unit bodies had been stripped of their frontmatter
      When the bodies are concatenated in manifest document order
      Then the result will match the source at the pinned commit character-for-character
