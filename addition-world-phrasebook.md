# Addition World Phrasebook — Ἡ τῆς Προσθέσεως Χώρα
**v0.2 — working draft for philological review**

Scope: the controlled Greek needed to state and play NNG4's Tutorial + Addition Worlds with exactly three moves (`rfl`, `rw`, `induction`). Register: Euclid's formulaic prose (Heiberg's text), with coinages flagged. Everything here is a *proposal to be vetted*, not settled canon.

**Provenance tags.** `[Eucl.]` attested formula (locus given, sometimes from memory — see §11); `[adapt.]` adapted from an attested pattern; `[coin.]` coinage; `[verify]` needs checking against Heiberg.

**Slot notation.** `{a:gen}` = a hole filled by a number-description in the genitive. The article at a slot belongs to the *filler*, not the frame: it inflects for the filler's own gender (ἐκ **τοῦ** Α but ἐκ **τῆς** δυάδος but ἐκ **τοῦ** οὐδενός). Templates are therefore functions of (case, filler-gender), not strings.

---

## 1. Design invariants

1. **Sentences are linearized trees.** Every goal, hypothesis, and move is the linearization of an AST. Rewriting happens on the tree and the sentence is *re-linearized*; string substitution is forbidden, because a rewrite can change the gender/case of surrounding material (replace ἡ δυάς by ὁ ἐφεξῆς τῆς μονάδος inside a genitive slot and the article flips τῆς → τοῦ).
2. **Agreement is the type checker.** Elided head nouns are recovered from article gender (ὁ … = sc. ἀριθμός throughout this world). Concord failure = elaboration error.
3. **Aspect separates move classes.** Present 3sg imperative = suppositional (enter a case branch); κεῖμαι-family imperatives (ὑποκείσθω, προσκείσθω…) = state-establishing (extend the context). Event-voice verbs (aorist προστεθῇ, προστεθείς) appear in προτάσεις and binders; state-voice descriptions (perfect-flavored συγκείμενος) appear in standing goals.
4. **Free logic budget.** The κοιναὶ ἔννοιαι of equality (symmetry, transitivity — CN 1's τὰ τῷ αὐτῷ ἴσα καὶ ἀλλήλοις ἐστὶν ἴσα, and its silent converse use) are the *only* reasoning granted for free; they power the ἐπεί-mechanism (§6.2). Everything else is a ὅρος the player is given or an αἴτημα the player must talk Euclid into.

---

## 2. Lexicon: atoms

| Object | Greek | Declension | Notes |
|---|---|---|---|
| the type ℕ | ὁ ἀριθμός | 2nd decl. masc. | All anonymous number-descriptions elide ἀριθμός and surface as bare masc. article + modifier. |
| bound variables | ὁ Α, ὁ Β, ὁ Γ, ὁ Δ … | letter indeclinable; article carries case | Introduced by ἔκθεσις (§4). Reserve **Ο** (collides with the zero glyph) and **Ϛ/ϛ**. `[Eucl.]` throughout VII–IX. |
| zero | τὸ οὐδέν, τοῦ οὐδενός, τῷ οὐδενί, τὸ οὐδέν | irregular, neuter | `[coin.]` as a proper name; cf. the tabular ο of Ptolemaic astronomy (often glossed as οὐδέν — `[verify]` the scholarship). Deliberately **anomalous in gender**: it is the one inhabitant of ℕ that Euclid does not yet believe in, and its grammar says so. A regularized ἡ οὐδενάς (-άδος, on the μονάς model) is held in reserve as an in-game "correction" proposed by a later editor character. |
| successor (succ) | ὁ ἐφεξῆς + gen. | adverb substantivized by the article; **only the article inflects**: ὁ / τοῦ / τῷ / τὸν ἐφεξῆς | `[adapt.]` from Aristotle, *Phys.* V.3, where τὸ ἐφεξῆς is *defined* as a terminus technicus of succession (τὸ ἐχόμενον, "the contiguous," is defined there too and is the fallback candidate). Case government (gen. vs dat.) is open question T1 (§11). Nests as a left-branching genitive chain: succ (succ 0) = ὁ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός. |
| 1, 2, 3, 4 | ἡ μονάς, ἡ δυάς, ἡ τριάς, ἡ τετράς (-άδος, -άδι, -άδα) | 3rd decl. fem. | `[Eucl.]` μονάς (VII def. 1); the -άς series is Nicomachean/Pythagorean number-name stock. Feminine on purpose: the gender heterogeneity (masc. descriptions, fem. numerals, neut. zero) exercises the agreement engine, which is the point of the project. |

**Word of the world:** πρόσθεσις "addition" `[Eucl./Gk. math]`; the verb is προστίθημι, "add to," with the **dative of the base** and the **added number as subject/patient**.

---

## 3. Term grammar: compound descriptions

### 3.1 Sum — `a + b`

Canonical description, two linear orders:

- **Sandwich (attributive) order:** ὁ ἐκ τοῦ {a:gen} καὶ τοῦ {b:gen} συγκείμενος — the article … participle frame *is the parenthesis*.
- **Head-first order:** ὁ συγκείμενος ἐκ τοῦ {a:gen} καὶ τοῦ {b:gen}.

`[adapt.]` from ὁ ἐκ τῶν Α, Β (γενόμενος), Euclid's product formula (VII.16 ff. `[verify locus]`), and from συγκείμενος itself, which sits inside the very definition of number: ἀριθμὸς δὲ τὸ ἐκ μονάδων συγκείμενον πλῆθος (VII def. 2). Note honestly: for *sums of numbers* Euclid's own corpus prefers segment-concatenation and προσκεῖσθαι (see 3.4); the συγκείμενος-description as a nestable sum term is our extension of X-book style to arithmetic — flag T2.

**Pair shortcut** when both arguments are same-gender atoms: ὁ ἐκ τῶν Α, Β συγκείμενος — asyndetic pair under a plural article `[Eucl. formula style]`.

### 3.2 Precedence devices (the answer to "no parentheses")

Greek supplies three bracketing mechanisms; the linearizer uses them by rule:

1. **Attributive sandwich — mandatory for embedded sums.** Whenever a sum-description occurs *inside* another description (under ἐφεξῆς, or as a conjunct of an outer sum), it must be linearized in sandwich order, so the closing participle delimits it: succ (a + b) = ὁ ἐφεξῆς **τοῦ** ἐκ τοῦ Α καὶ τοῦ Β **συγκειμένου**.
2. **Two-tier coordination = two precedence levels.** Inner pairs of atoms: asyndetic plural article (τῶν Α, Β). Outer coordination, when a conjunct is itself a συγκείμενος-phrase: ἔκ **τε** τοῦ … **καὶ** τοῦ … — the postpositive τε marks the first conjunct of the *outer* pair. Thus:
   - `(a+b)+c` = ὁ ἔκ τε τοῦ ἐκ τῶν Α, Β συγκειμένου καὶ τοῦ Γ συγκείμενος
   - `a+(b+c)` = ὁ ἔκ τε τοῦ Α καὶ τοῦ ἐκ τῶν Β, Γ συγκειμένου συγκείμενος
   τε is optional when both conjuncts are ἐφεξῆς-chains or atoms: a chain always terminates in an atom, and atoms take no complement, so a following καί can only attach at the sum level — the grammar itself is unambiguous there.
3. **ANF escape hatch — the authentic style.** Beyond nesting depth 2, bind the intermediate to a fresh letter, on the model of Euclid's multiplication formula ὁ Α τὸν Β πολλαπλασιάσας τὸν Γ ποιείτω (VII `[verify locus]`):

   > **ὁ Α τῷ Β προστεθεὶς τὸν Γ ποιείτω.** `[adapt.]`
   > "Let Α, added to Β, make Γ." — introduces Γ ≔ Α + Β into the context.

   Euclid's arithmetic books are effectively in A-normal form; the parser may *require* ποιείτω-binding past depth 2, sold in-game as Euclid's stylistic insistence.

*Pretty-printer note:* at clause-top positions (subject of ἐστί, dative object of ἴσος) either order is legal; prefer head-first there when sandwich order would abut two participles (see add_assoc, §9, where …συγκειμένου συγκειμένῳ is avoided by flipping the outer description to head-first). This is heavy-NP shift doing the job of a line-breaking heuristic.

### 3.3 Equality

- **Propositional equality** (`a = b`): {a:nom} **ἴσος ἐστὶ** τῷ {b:dat}, with ἴσος agreeing with the *subject's* head gender: ὁ συγκείμενος … ἴσος ἐστί…, ἡ δυὰς … ἴση ἐστί…, τὸ οὐδὲν … ἴσον ἐστί…. Plural subjects: ἴσοι/ἴσαι/ἴσα εἰσί(ν); "equal to one another" = ἴσοι ἀλλήλοις `[Eucl. CN 1]`.
- **Definitional equality / identity:** ὁ αὐτός + dat., or predicative ταὐτόν. Reserved for the `rfl` move (§6.1) and for the machine's ταὐτὸν λέγεις. Euclid proves things ἴσα; he never *thematizes* sameness of description, because he has objects, not expressions — which is exactly why defeq gets a different word.

### 3.4 Attested addition verbs (for flavor and later use)

προσκείσθω τῷ ΔΕ μονὰς ἡ ΔΖ — "let the unit ΔΖ be added to ΔΕ" `[Eucl. IX 20, quoted from memory — verify wording]`. The κεῖμαι-imperative here is the state-establishing binder par excellence; our ποιείτω-formula in 3.2 is its systematized cousin.

---

## 4. The proposition scaffold (Proclus's six parts as proof-script skeleton)

| Part | Formula | Role |
|---|---|---|
| πρότασις | general ἐάν + subj. statement (see §5) | theorem statement, displayed |
| ἔκθεσις | **ἔστω ἀριθμὸς ὁ Α.** / ἔστωσαν ἀριθμοὶ οἱ Α, Β. `[Eucl.]` | `intro` — binds the letters |
| διορισμός | **λέγω ὅτι** [goal sentence]. `[Eucl.]` | `show` — states the lettered goal |
| κατασκευή | κεῖμαι-imperatives; ποιείτω-bindings | `have` / `obtain` / `set` |
| ἀπόδειξις | the ἐπεί / ὑπόκειται / γάρ chain | the tactic block |
| συμπέρασμα | **ὅπερ ἔδει δεῖξαι.** `[Eucl.]` | QED, spoken by the machine |

**Goal display.** After the διορισμός the current goal is always echoed as **δεικτέον ὅτι** […] ("it must be shown that…", verbal adjective in -τέον). After a rewrite: **τουτέστι δεικτέον ὅτι** […] — the scholiasts' paraphrase-marker as rewrite trace. When a move opens two goals: **δύο δὴ δεικτέα ἐστίν.** (neuter plural subject with singular verb — the agreement quirk is correct and intended). When one of two goals closes: **λοιπὸν δὴ δεικτέον ὅτι** […].

**Taxonomy of givens.** ὅροι (definitions: the two clauses defining addition, and the numeral definitions, §5); one αἴτημα (postulate: ἐπαγωγή, §6.3); κοιναὶ ἔννοιαι (the ambient equality logic, §1.4).

---

## 5. The givens (ὅροι)

### 5.1 ὅρος τῆς προσθέσεως, first clause — `add_zero : a + 0 = a`

- πρότασις: **ἐὰν ἀριθμῷ τινι τὸ οὐδὲν προστεθῇ, ὁ γενόμενος τῷ ἐξ ἀρχῆς ἴσος ἐστίν.**
  "If to some number the nothing be added, the result is equal to the original." — τῷ ἐξ ἀρχῆς `[Eucl.]` "the original"; ὁ γενόμενος `[Eucl.]` "the resulting one."
- Instance schema (citable form): **ὁ συγκείμενος ἐκ τοῦ {a:gen} καὶ τοῦ οὐδενὸς ἴσος ἐστὶ τῷ {a:dat}.**

### 5.2 ὅρος τῆς προσθέσεως, second clause — `add_succ : a + succ b = succ (a + b)`

- πρότασις: **ἐὰν ἀριθμῷ τινι ὁ ἑτέρου τινὸς ἐφεξῆς προστεθῇ, ὁ γενόμενος ἐφεξῆς ἐστι τοῦ ἐξ ἀμφοῖν συγκειμένου.**
  "If to some number the successor of some other be added, the result is the successor of the one composed of both." — ἀμφοῖν: gen. dual of ἄμφω, resolving anaphorically to the pair (base, other). Strict paraphrase if the dual is judged too cute: τοῦ ἔκ τε τοῦ πρώτου καὶ τοῦ ἑτέρου συγκειμένου.
- Instance schema: **ὁ συγκείμενος ἐκ τοῦ {a:gen} καὶ τοῦ ἐφεξῆς τοῦ {b:gen} ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐκ τοῦ {a:gen} καὶ τοῦ {b:gen} συγκειμένου.**

**Design note (asymmetry made audible).** Peano addition recurses on the *second* argument; the Greek voicing encodes this: the dative marks the inert base, the nominative-added (ὁ προστεθείς) is the argument the recursion consumes. The anaphors in the two προτάσεις name the surviving argument — τῷ ἐξ ἀρχῆς in 5.1, and in `zero_add` (§8) it will be τῷ προστεθέντι. Anaphora *is* the term language.

### 5.3 ὅροι of the numerals — `one_eq_succ_zero` … `four_eq_succ_three`

- **ἡ μονάς ἐστιν ὁ ἐφεξῆς τοῦ οὐδενός.**
- **ἡ δυάς ἐστιν ὁ ἐφεξῆς τῆς μονάδος.**
- **ἡ τριάς ἐστιν ὁ ἐφεξῆς τῆς δυάδος.**
- **ἡ τετράς ἐστιν ὁ ἐφεξῆς τῆς τριάδος.**

Predicate substantives keep their own gender (fem. subject, masc. predicate description — regular Greek; see the 文典 on nominal predicates). These are ὅροι: rewrite-citable in either direction.

---

## 6. The three player moves

### 6.1 Closing a goal — `rfl`

> Player: **ὁ αὐτὸς γάρ ἐστι.** (ἡ αὐτὴ γάρ ἐστι / τὸ αὐτὸ γάρ ἐστι, agreeing with the goal's subject.)
> Machine, if both sides are the same description after unfolding ὅροι: **ταὐτὸν λέγεις.** — then, if it was the last goal: **ὅπερ ἔδει δεῖξαι.**

CN 1 is *transitivity* — the engine that lets ἐπεί-steps chain. What closes the proof is identity of description, a metalinguistic notion Euclid never needs to name; the machine naming it (ταὐτὸν λέγεις, with the crasis ταὐτόν) is the dramatization of definitional equality.

### 6.2 Rewriting — `rw [h]`

> Player: **ἐπεὶ** [fully lettered instance of a ὅρος or previously proven theorem, stated in the orientation to be applied left→right]**,**
> Machine: **τουτέστι δεικτέον ὅτι** [re-linearized goal]**.**

Rules:

- The instance is stated *fully instantiated* (Euclid cites by restatement, not by name); the elaborator unifies it against the known ὅροι/theorems and rejects unknowns. Optional tag when citing a previously proven level: **ὡς ἐδείχθη** "as was shown."
- Orientation: the equation is applied left→right *as the player states it*; to rewrite the other way, state it flipped — symmetry of ἴσος is a κοινὴ ἔννοια and free. (ἀνάπαλιν `[Eucl. V, of inverted ratios]` is reserved as an alternative marker; decision T3.)
- Occurrences: all occurrences of the stated left side are rewritten (Lean `rw` semantics). Pointed/single-occurrence rewriting is deferred to the click-a-constituent UI (conv-by-pointing), where the machine speaks the instance the player selected.
- Citing a *hypothesis* (e.g., the induction hypothesis) uses the hypothesis-marker instead of ἐπεί:
  > Player: **ὑπόκειται δὲ** τὸν {lhs:acc} ἴσον εἶναι τῷ {rhs:dat}**.** — "but it stands supposed that…" (acc. + inf. after ὑπόκειται; a ὅτι-clause is the tolerated variant).

### 6.3 Induction — `induction b` (ἐπαγωγή)

Prerequisite: the αἴτημα must have been "purchased" in-game (the sorites objection and the descent argument via VII 31's ὅπερ ἐστὶν ἀδύνατον ἐν ἀριθμοῖς belong to the plot, not this phrasebook).

> **Αἴτημα (τὸ τῆς ἐπαγωγῆς).** ἐὰν πάθος τι ὑπάρχῃ τῷ οὐδενί, ὑπάρχῃ δὲ καὶ τῷ ἐφεξῆς παντὸς ἀριθμοῦ ᾧ ἂν ὑπάρχῃ, παντὶ ἀριθμῷ ὑπάρξει.
> "If some property belongs to the nothing, and belongs also to the successor of every number to which it belongs, it will belong to every number." — ὑπάρχειν for predication `[adapt. Aristotle]`; πάθος for arithmetic property `[adapt. Aristotle]`; ᾧ ἂν ὑπάρχῃ: generalizing relative with ἄν + subjunctive.

The move itself is a three-sentence protocol, deliberately parallel to the VII.3 pattern you found (ἤτοι … ἢ …· μετρείτω πρότερον· … μὴ μετρείτω δή):

1. **Dichotomy** (this alone = `cases`): Player: **ὁ Β ἤτοι τὸ οὐδέν ἐστιν ἢ ἐφεξῆς τινος.** Machine: **δύο δὴ δεικτέα ἐστίν.** [+ both goals]
2. **Base branch:** Player: **ἔστω πρότερον τὸ οὐδέν.** Machine: **δεικτέον ὅτι** [goal with Β ≔ τὸ οὐδέν].
3. **Step branch** (after the base closes; machine has said λοιπὸν δή…): Player: **ἔστω δὴ ὁ Β ἐφεξῆς ἀριθμοῦ τινος τοῦ Δ, καὶ ὑποκείσθω** [P(Δ) in acc. + inf.]**.**
   - The apposition ἀριθμοῦ τινος τοῦ Δ binds the fresh letter Δ (the `n` in `succ n`).
   - **ὑποκείσθω** — pres. impv. mid. 3sg of ὑπόκειμαι, the verb behind ὑπόθεσις; κεῖμαι-family, hence state-establishing per §1.3 — introduces the induction hypothesis. Its legality is exactly what distinguishes ἐπαγωγή from mere διαίρεσις: without the αἴτημα the parser rejects the ὑποκείσθω-clause.

---

## 7. Tutorial World boss — ἡ δυὰς καὶ ἡ δυάς: `2 + 2 = 4`

*Tutorial World's boss, not Addition World's.* This level is cleared before the player ever meets the general, variable-quantified lemmas of §8–§9. The numbers here are concrete numerals, so no ἐπαγωγή (§6.3) is needed at all — only the ὅροι of §5, cited concretely by ἐπεί (§6.2), and the closing ὁ αὐτὸς γάρ ἐστι (§6.1). It exercises exactly the two moves Tutorial World has taught so far and no more, which is the point: Addition World's own levels (§8–§9) need `induction` precisely because their arguments are variables that this boss never has to face.

διορισμός: **λέγω ὅτι ὁ συγκείμενος ἐκ τῆς δυάδος καὶ τῆς δυάδος ἴσος ἐστὶ τῇ τετράδι.**
(Friendly πρότασις for the level card: **ἡ δυὰς τῇ δυάδι προστεθεῖσα τετράδα ποιεῖ.**)

Full trace. Player lines are ἐπεί-citations of ὅροι (all-occurrence rewriting); each is followed by the machine's τουτέστι δεικτέον ὅτι + the goal shown.

1. **ἐπεὶ ἡ τετράς ἐστιν ὁ ἐφεξῆς τῆς τριάδος,**
   → ὁ συγκείμενος ἐκ τῆς δυάδος καὶ τῆς δυάδος ἴσος ἐστὶ τῷ ἐφεξῆς τῆς τριάδος.
2. **ἐπεὶ ἡ τριάς ἐστιν ὁ ἐφεξῆς τῆς δυάδος,**
   → … ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τῆς δυάδος.
3. **ἐπεὶ ἡ δυάς ἐστιν ὁ ἐφεξῆς τῆς μονάδος,** (rewrites all three occurrences)
   → ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τῆς μονάδος καὶ τοῦ ἐφεξῆς τῆς μονάδος ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τῆς μονάδος.
   (Note the articles re-inflecting under rewrite: τῆς δυάδος → τοῦ ἐφεξῆς τῆς μονάδος. String substitution would have produced gender garbage; the tree was re-linearized.)
4. **ἐπεὶ ἡ μονάς ἐστιν ὁ ἐφεξῆς τοῦ οὐδενός,**
   → ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός.
5. **ἐπεὶ ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ οὐδενὸς συγκειμένου,** (= 5.2 with a ≔ σσ0, b ≔ σ0)
   → ὁ ἐφεξῆς τοῦ ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ οὐδενὸς συγκειμένου ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός.
6. **ἐπεὶ ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ οὐδενὸς ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ οὐδενὸς συγκειμένου,** (= 5.2 with a ≔ σσ0, b ≔ 0)
   → ὁ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ οὐδενὸς συγκειμένου ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός.
7. **ἐπεὶ ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς καὶ τοῦ οὐδενὸς ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός,** (= 5.1 with a ≔ σσ0)
   → ὁ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενὸς ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ ἐφεξῆς τοῦ οὐδενός.
8. **ὁ αὐτὸς γάρ ἐστι.** — **ταὐτὸν λέγεις· ὅπερ ἔδει δεῖξαι.**

Your original joke, verbatim realized: "two and two added together" collapses into the successor-of-the-successor-of-… litany, and the proof ends the moment the two litanies coincide. In the UI, steps 5–7 are where the player will *point* at the subterm and the machine will speak these monsters; and where Euclid, if asked, recommends ποιείτω-binding instead.

---

## 8. Worked level — Addition World 1: `zero_add : 0 + a = a`

πρότασις: **ἐὰν τῷ οὐδενὶ ἀριθμός τις προστεθῇ, ὁ γενόμενος τῷ προστεθέντι ἴσος ἐστίν.**
(Contrast 5.1: the same frame with οὐδέν moved from the added-slot to the base-slot, and the surviving argument renamed by its role-anaphor τῷ προστεθέντι. προστεθῇ: aor. pass. subj. 3sg — the generalizing condition of a πρότασις.)

| # | Speaker | Sentence | Lean |
|---|---|---|---|
| 1 | player | ἔστω ἀριθμὸς ὁ Α. | `intro a` |
| 2 | player | λέγω ὅτι ὁ συγκείμενος ἐκ τοῦ οὐδενὸς καὶ τοῦ Α ἴσος ἐστὶ τῷ Α. | `show 0 + a = a` |
| 3 | player | ὁ Α ἤτοι τὸ οὐδέν ἐστιν ἢ ἐφεξῆς τινος. | `induction a` (opening) |
| 4 | machine | δύο δὴ δεικτέα ἐστίν. | two goals |
| 5 | player | ἔστω πρότερον τὸ οὐδέν. | enter base case |
| 6 | machine | δεικτέον ὅτι ὁ συγκείμενος ἐκ τοῦ οὐδενὸς καὶ τοῦ οὐδενὸς ἴσος ἐστὶ τῷ οὐδενί. | `⊢ 0 + 0 = 0` |
| 7 | player | ἐπεὶ ὁ συγκείμενος ἐκ τοῦ οὐδενὸς καὶ τοῦ οὐδενὸς ἴσος ἐστὶ τῷ οὐδενί, | `rw [add_zero]` (a ≔ 0) |
| 8 | machine | τουτέστι δεικτέον ὅτι τὸ οὐδὲν ἴσον ἐστὶ τῷ οὐδενί. | `⊢ 0 = 0` |
| 9 | player | τὸ αὐτὸ γάρ ἐστι. | `rfl` |
| 10 | machine | ταὐτὸν λέγεις. λοιπὸν δὴ δεικτέον τὸ ἕτερον. | base closed |
| 11 | player | ἔστω δὴ ὁ Α ἐφεξῆς ἀριθμοῦ τινος τοῦ Δ, καὶ ὑποκείσθω τὸν ἐκ τοῦ οὐδενὸς καὶ τοῦ Δ συγκείμενον ἴσον εἶναι τῷ Δ. | step case, `ih : 0 + d = d` |
| 12 | machine | δεικτέον ὅτι ὁ συγκείμενος ἐκ τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ Δ ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ Δ. | `⊢ 0 + succ d = succ d` |
| 13 | player | ἐπεὶ ὁ συγκείμενος ἐκ τοῦ οὐδενὸς καὶ τοῦ ἐφεξῆς τοῦ Δ ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐκ τοῦ οὐδενὸς καὶ τοῦ Δ συγκειμένου, | `rw [add_succ]` |
| 14 | machine | τουτέστι δεικτέον ὅτι ὁ ἐφεξῆς τοῦ ἐκ τοῦ οὐδενὸς καὶ τοῦ Δ συγκειμένου ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ Δ. | `⊢ succ (0 + d) = succ d` |
| 15 | player | ὑπόκειται δὲ τὸν ἐκ τοῦ οὐδενὸς καὶ τοῦ Δ συγκείμενον ἴσον εἶναι τῷ Δ. | `rw [ih]` |
| 16 | machine | τουτέστι δεικτέον ὅτι ὁ ἐφεξῆς τοῦ Δ ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ Δ. | `⊢ succ d = succ d` |
| 17 | player | ὁ αὐτὸς γάρ ἐστι. | `rfl` |
| 18 | machine | ταὐτὸν λέγεις. ἐὰν ἄρα τῷ οὐδενὶ ἀριθμός τις προστεθῇ, ὁ γενόμενος τῷ προστεθέντι ἴσος ἐστίν· **ὅπερ ἔδει δεῖξαι.** | QED; συμπέρασμα restates the πρότασις with ἄρα |

Grammar exercised: aor. pass. subjunctive (προστεθῇ), acc. + inf. after ὑπόκειμαι, enclitic accent sandhi (ἐφεξῆς τινος, ἀριθμοῦ τινος: enclitic loses its accent after a perispomenon), neuter-plural-with-singular-verb (line 4), and the sandwich as bracket (lines 13–15).

---

## 9. Levels 2–5: statements and skeletons

**Level 2 — `succ_add : succ a + b = succ (a + b)`.**
πρότασις: **ἐὰν τῷ ἐφεξῆς ἀριθμοῦ τινος ἕτερος ἀριθμὸς προστεθῇ, ὁ γενόμενος ἐφεξῆς ἐστι τοῦ ἐκ τοῦ πρώτου καὶ τοῦ προστεθέντος συγκειμένου.**
διορισμός: λέγω ὅτι ὁ συγκείμενος ἐκ τοῦ ἐφεξῆς τοῦ Α καὶ τοῦ Β ἴσος ἐστὶ τῷ ἐφεξῆς τοῦ ἐκ τῶν Α, Β συγκειμένου.
Skeleton: ἐπαγωγή on ὁ Β. Base: one ἐπεί with 5.1 rewrites *both* …+ οὐδέν occurrences at once (`rw [add_zero]` hits both sides), then ὁ αὐτὸς γάρ ἐστι. Step: two ἐπεί with 5.2 (each side), then ὑπόκειται δέ…, then closure.

**Level 3 — `add_comm : a + b = b + a`.**
πρότασις: **ἐὰν δύο ἀριθμῶν ἑκάτερος ἑκατέρῳ προστεθῇ, οἱ γενόμενοι ἴσοι ἀλλήλοις εἰσίν.** — the distributive idiom ἑκάτερος ἑκατέρῳ `[Eucl., cf. I 4 ἑκατέρα ἑκατέρᾳ]`; ἴσοι ἀλλήλοις straight from CN 1.
διορισμός: λέγω ὅτι ὁ ἐκ τῶν Α, Β συγκείμενος ἴσος ἐστὶ τῷ ἐκ τῶν Β, Α συγκειμένῳ.
Skeleton: ἐπαγωγή on ὁ Β; base uses 5.1 and Level 1 (cited with ὡς ἐδείχθη); step uses 5.2 and Level 2.

**Level 4 — `add_assoc : (a + b) + c = a + (b + c)` — Addition World boss.**
διορισμός: **λέγω ὅτι ὁ ἔκ τε τοῦ ἐκ τῶν Α, Β συγκειμένου καὶ τοῦ Γ συγκείμενος ἴσος ἐστὶ τῷ συγκειμένῳ ἔκ τε τοῦ Α καὶ τοῦ ἐκ τῶν Β, Γ συγκειμένου.**
Both precedence tiers on display: τε…καί for the outer pair, asyndetic τῶν Α, Β / τῶν Β, Γ for the inner, sandwiches for embedded sums — and on the right the outer description flipped to head-first (τῷ συγκειμένῳ ἔκ τε…) to avoid the participle collision …συγκειμένου συγκειμένῳ. This is Addition World's own boss: unlike the Tutorial World boss (§7), it is quantified over three variables, so there is no computational shortcut — the full ἐπαγωγή-plus-precedence machinery is unavoidable, which is exactly the payoff of having played §8–§9 first.
General πρότασις (loose): ἐὰν τρεῖς ἀριθμοὶ συντεθῶσιν, οὐδὲν διαφέρει ὁποτέρωθεν ἄρξηταί τις `[coin.? — T5]`.
Skeleton: ἐπαγωγή on ὁ Γ.

**Level 5 — `add_right_comm` (epilogue).** Pure rewriting with Levels 3–4; no new vocabulary. Statement omitted here.

---

## 10. Morphology appendix (closed inventory)

### 10.1 Nominals

- **Article** (the workhorse; carries most case information): sg. ὁ τοῦ τῷ τόν / ἡ τῆς τῇ τήν / τό τοῦ τῷ τό; pl. οἱ τῶν τοῖς τούς / αἱ τῶν ταῖς τάς / τά τῶν τοῖς τά; dual nom.-acc. τώ, gen.-dat. τοῖν (for ἀμφοῖν-flavored moments).
- **-άς, -άδος** feminines: μονάς μονάδος μονάδι μονάδα; likewise δυάς, τριάς, τετράς. (pl. -άδες -άδων -άσι(ν) -άδας, not yet needed.)
- **οὐδέν** οὐδενός οὐδενί οὐδέν (neut.).
- **συγκείμενος -η -ον**, **γενόμενος**, **προστεθείς προστεθέντος προστεθέντι προστεθέντα**, **ἴσος ἴση ἴσον** (pl. ἴσοι ἴσαι ἴσα): standard 1st/2nd-declension adjective/participle patterns; προστεθείς is 3rd-declension aor. pass. participle.
- **ἐφεξῆς**: indeclinable; the article does all the work.

### 10.2 Verb-form inventory (complete for this world)

ἐστί(ν), εἰσί(ν), ἔστω, ἔστωσαν, εἶναι · προστεθῇ, προστεθείς, προσκείσθω · σύγκειται, συγκείμενος · ποιεῖ, ποιείτω · ὑπόκειται, ὑποκείσθω · ὑπάρχει, ὑπάρχῃ, ὑπάρξει · λέγω, λέγεις · δεῖξαι, ἐδείχθη, δεικτέον · γίγνεται (spare) · μετρεῖ, μετρείτω (preview of Division World).

### 10.3 Linearizer passes (in order)

1. **Agreement**: articles/adjectives/participles from filler gender + demanded case; predicate adjectives from subject head; neuter plural subject → singular verb.
2. **Postpositive placement** (Wackernagel P2): δέ, γάρ, ἄρα, τε, δή placed second in their clause/phrase — a post-processing pass, and yes, Wackernagel's Law as a compiler stage.
3. **Enclisis**: ἐστι(ν), εἰσι(ν), τις/τινος/τινι, τε — accent sandhi per the 文典's enclitic tables (host oxytone: keeps acute, enclitic bare — οὐδενός ἐστιν; host perispomenon: enclitic bare — ἐφεξῆς τινος; host paroxytone + disyllabic enclitic: enclitic keeps accent — ἴσον ἐστί…).
4. **Movable ν**: ἐστί(ν)/εἰσί(ν) and dat. pl. -σι(ν) before vowel or pause.
5. **Grave/acute finals**: acute → grave mid-phrase (οὐδενὸς καί vs οὐδενός.).
6. Elision (δ᾿, ἀλλ᾿) and crasis beyond frozen ταὐτόν: **off** in v0.1.

Input normalization: accept unaccented/monotonic input and letters without articles from the palette; the printer always emits full polytonic.

---

## 11. Open questions & philological TODO

- **T1. Case government of substantivized ἐφεξῆς.** ὁ ἐφεξῆς τοῦ Α (gen.) vs ὁ ἐφεξῆς τῷ Α (dat.). Check LSJ s.vv. ἑξῆς, ἐφεξῆς and Aristotle *Phys.* V.3's own construction; also grep Heiberg for ἑξῆς/ἐφεξῆς usage (IX's ἑξῆς ἀνάλογον is adverbial). Genitive nests better; dative may be the more classical adjacency case.
- **T2. συγκείμενος for sums of numbers.** Attested for magnitudes and inside VII def. 2; collate whether arithmetic books ever use it for a sum-of-two-numbers description, or only προσκεῖσθαι + segment concatenation. If the latter, keep συγκείμενος as our deliberate systematization and let the in-game Euclid grumble once.
- **T3. Reverse rewriting.** Current rule: state the equation in the orientation you want (symmetry free). Alternative: mandatory ἀνάπαλιν marker. Decide after playtesting.
- **T4. Zero's grammar.** Anomalous τὸ οὐδέν (current) vs regularized ἡ οὐδενάς. Also verify the Ptolemy-ο-as-οὐδέν story before putting it in a character's mouth.
- **T5. add_assoc general πρότασις.** ὁποτέρωθεν ἄρξηταί τις is a coinage on the ἑκατέρωθεν model; find or forge better.
- **T6. Verify from Heiberg (quoted from memory above):** IX 20 προσκείσθω wording; VII 16 ff. product formula ὁ ἐκ τῶν Α, Β; VII 31 ὅπερ ἐστὶν ἀδύνατον ἐν ἀριθμοῖς; exact form of the multiplication ποιείτω-formula.
- **T7. Argument order.** ὁ συγκείμενος ἐκ τοῦ {a} καὶ τοῦ {b} linearizes `a + b` in that order, and the προστίθημι-frame maps dative = 1st argument, nominative = 2nd (recursion) argument. Confirm this matches the Lean definition you implement against, or the ἐπεί-unifier will fight you.
- **T8. Multi-goal bookkeeping.** Is δύο δὴ δεικτέα ἐστίν + λοιπὸν δή enough, or do goals need labels (τὸ μὲν πρῶτον … τὸ δὲ δεύτερον)?

---

*Next worlds will need:* πολλαπλασιάζω and the ποιείτω-formula in earnest (Multiplication), Diophantus's δύναμις/κύβος/δυναμοδύναμις series (Power), μετρεῖ and the ἤτοι-split (Division/Advanced), εἰ γὰρ δυνατόν … ὅπερ ἄτοπον (≠-levels), and τις/εἰλήφθω for existentials (≤ World).
