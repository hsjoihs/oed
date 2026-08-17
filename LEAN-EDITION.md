# The Lean-elaborator edition: deviations from the phrasebook

The phrasebook (`addition-world-phrasebook.md`) is the design reference;
this Lean 4 implementation deviates from it deliberately in these points.

## Orthography

- **Uppercase, no accents, no breathings** — the epigraphic reality of
  Euclid's own era; accents are Alexandrian editorial technology. This
  deletes the enclisis and grave-accent linearizer passes (phrasebook
  §10.3 passes 3 and 5) outright.
- **Movable ν**: the printer always emits ΕΣΤΙΝ; input accepts both
  ΕΣΤΙ and ΕΣΤΙΝ. (Phrasebook pass 4 deferred.)
- **No sentence-final punctuation** on tactic sentences; ΕΠΕΙ keeps its
  clause-final comma (a subordinate clause), matching the worked traces.
- Unaccented collapse to watch: ἡ (article), ἤ ("or") → both Η. The
  ΗΤΟΙ … Η dichotomy sentence is a fixed frame, so no ambiguity arises.

## Grammar and engine

- **Reserved letters**: Ο (masc. article; also the zero-glyph collision
  the phrasebook already reserves) and Η (fem. article / disjunction)
  cannot be variables. Α Β Γ Δ Ε Ζ are available.
- **Embedded sums are sandwich-only** (gen. slots); clause-top positions
  (nom./dat./acc.) also allow head-first. This makes the no-parentheses
  grammar strictly unambiguous — the phrasebook's pretty-printer note
  promoted to a parser rule.
- **ΕΠΕΙ cites one occurrence class.** The citation is fully
  instantiated, so it rewrites occurrences of *that instance's* LHS.
  Where NNG's `rw [add_zero]` hits both `…+0` subterms of `succ_add`'s
  base goal at once (phrasebook §9 note), this edition takes two ΕΠΕΙ.
- **Citation matching runs at reducible transparency.** At default
  transparency every closed equation of this world is defeq to every
  other (everything computes), so ὅρος-matching must be syntactic up to
  instantiating the fact's variables. Definitional equality remains the
  semantics of the *rfl move* (ταὐτόν), exactly the phrasebook's
  ἴσος/ταὐτόν split.
- **The IH is named ΘΕΜΑ** in the local context ("that which is laid
  down") — ΥΠΟΘΕΣΙΣ itself contains Π/Σ, which Lean identifiers reject.
- **ΩΣ ΕΔΕΙΧΘΗ is optional and semantically inert** (decision matching
  §6.2): proven ΠΡΟΤΑΣΕΙΣ enter the same @[horos] registry as the ὅροι.
- **The αἴτημα gate on ἐπαγωγή is not enforced** — the sorites
  set-piece is plot, not engine, and is deferred with it.
- **The general ἐάν-πρότασις is not part of the ΠΡΟΤΑΣΙΣ command** —
  the lettered διορισμός doubles as the theorem statement. The ἐάν
  sentences remain display flavor for the game layer.

## Scripta continua (the ΣΥΝΕΧΩΣ layer)

- One sentence per line; the block terminator is the line
  ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ; the block opener is the marker ΣΥΝΕΧΩΣ (a coinage of
  convenience — the παράγραφος of this medium).
- Letter-variables are spelled out (ΑΛΦΑ ΒΗΤΑ ΓΑΜΜΑ ΔΕΛΤΑ … → Α Β Γ Δ …),
  since continua cannot delimit a bare letter.
- The lexer restores the asyndetic-pair commas (ΤΩΝ Α, Β) and ΕΠΕΙ's
  clause-final comma; everything else feeds the ordinary spaced grammar
  via `runParserCategory`, unchanged.

## Two Lean-internals findings worth retelling

1. **Tactic-leading keywords must lex as one identifier.** The `tactic`
   category uses `LeadingIdentBehavior.symbol`, so the *first* atom of a
   tactic rule compiles to `nonReservedSymbol` — and ΕΠΕΙ/ΕΣΤΩ/ΥΠΟΚΕΙΤΑΙ
   contain Π/Σ, which are not identifier characters in Lean. Fix: wrap
   each leading keyword in its own syntax category, where it registers as
   an ordinary token (`Oed/Moves.lean`).
2. **Lean's tokenizer cannot be taught scripta continua** (maximal-munch
   identifiers, keywords at token boundaries), but a raw `ParserFn` may
   consume anything — the ΣΥΝΕΧΩΣ command owns its block and re-enters
   the parser through the front door (`Oed/Continua.lean`).
