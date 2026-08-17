/-
The three player moves (phrasebook §6), as Lean tactics.

- ΕΠΕΙ <sentence>,           = rw with a fully-instantiated citation.
  The cited equation is elaborated to `lhs = rhs` and must be justified
  by some @[horos] fact (unification with metavariables); Euclid cites
  by restatement, never by name. Optional tag: ΩΣ ΕΔΕΙΧΘΗ.
- ΥΠΟΚΕΙΤΑΙ ΔΕ <acc.+inf.>   = rw with a hypothesis (the IH).
- Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ           = rfl (machine: ΤΑΥΤΟΝ ΛΕΓΕΙΣ);
  the pronoun agrees with the goal subject's gender.
- ἐπαγωγή protocol (three sentences):
    Ο Β ΗΤΟΙ ΤΟ ΟΥΔΕΝ ΕΣΤΙΝ Η ΕΦΕΞΗΣ ΤΙΝΟΣ   (= induction; ΔΥΟ ΔΗ ΔΕΙΚΤΕΑ ΕΣΤΙΝ)
    ΕΣΤΩ ΠΡΟΤΕΡΟΝ ΤΟ ΟΥΔΕΝ                    (enter base branch)
    ΕΣΤΩ ΔΗ Ο Β ΕΦΕΞΗΣ ΑΡΙΘΜΟΥ ΤΙΝΟΣ ΤΟΥ Δ ΚΑΙ ΥΠΟΚΕΙΣΘΩ <IH acc.+inf.>
      (enter step branch, bind Δ, install the IH under the name ΘΕΜΑ;
       the stated IH must match the actual one)

Free logic budget: symmetry/transitivity of ἴσος are the κοιναὶ ἔννοιαι
(free via `Eq`); the ΕΠΕΙ engine grants nothing beyond @[horos].
Machine error messages, philologically:
  ΑΣΑΦΕΣ ΛΕΓΕΙΣ           "you speak unclearly"  (bad citation/agreement/case)
  ΟΥΔΕΝ ΠΡΟΣ ΕΠΟΣ ΛΕΓΕΙΣ  "nothing to the point" (rewrite finds no occurrence)
  ΟΥ ΤΑΥΤΟΝ ΛΕΓΕΙΣ        "not the same thing"   (rfl fails)
  ΟΥ ΤΟΥΤΟ ΥΠΟΚΕΙΤΑΙ      "that is not supposed" (IH mismatch)
-/
import Oed.Display

namespace Oed

open Lean Meta Elab Tactic

/-! ### The acc.+inf. clause (after ΥΠΟΚΕΙΤΑΙ ΔΕ / ΥΠΟΚΕΙΣΘΩ) -/

declare_syntax_cat accInf
syntax arithAcc " ΙΣΟΝ " "ΕΙΝΑΙ " arithDat : accInf
syntax arithAcc " ΙΣΗΝ " "ΕΙΝΑΙ " arithDat : accInf

/-- Gender of an accusative description, read off its leading article. -/
private def accGender (stx : Syntax) : Char :=
  let tok := stx[0].getAtomVal.trimAscii
  if tok == "ΤΗΝ" then 'f' else if tok == "ΤΟ" then 'n' else 'm'

/-- Expand to `lhs = rhs` plus (subject gender, adjective gender). -/
def accInfToTerm : Syntax → MacroM (TSyntax `term × Char × Char)
  | `(accInf| $a:arithAcc ΙΣΟΝ ΕΙΝΑΙ $d:arithDat) => do
      let t ← `($(← accToTerm a) = $(← datToTerm d))
      return (t, accGender a, 'm')  -- ΙΣΟΝ serves masc. and neut.
  | `(accInf| $a:arithAcc ΙΣΗΝ ΕΙΝΑΙ $d:arithDat) => do
      let t ← `($(← accToTerm a) = $(← datToTerm d))
      return (t, accGender a, 'f')
  | _ => Macro.throwUnsupported

/-- ΙΣΟΝ serves masc. and neut. accusative; ΙΣΗΝ is feminine. -/
def checkAccAgreement (subj adj : Char) : TacticM Unit := do
  unless (adj == 'f') == (subj == 'f') do throwError "ΑΣΑΦΕΣ ΛΕΓΕΙΣ"

/-! ### Sentence elaboration and the ΕΠΕΙ engine -/

def elabSentence (t : TSyntax `term) : TacticM Expr :=
  withMainContext do
    let e ← Tactic.elabTerm t (some (mkSort .zero))
    instantiateMVars e

/-- Justify a cited equation from the @[horos] registry alone. -/
def proveByHoroi (prop : Expr) : TacticM Expr := withMainContext do
  let names ← Lean.labelled `horos
  for n in names do
    try
      let e ← mkConstWithFreshMVarLevels n
      let (args, _, concl) ← forallMetaTelescope (← inferType e)
      -- reducible transparency: the citation must match the fact's statement
      -- syntactically (up to instantiating its variables). At default
      -- transparency everything in this world is defeq to everything
      -- (all closed terms compute), and the wrong ὅρος would "match".
      if ← withReducible <| isDefEq concl prop then
        return ← instantiateMVars (mkAppN e args)
    catch _ => pure ()
  throwError "ΑΣΑΦΕΣ ΛΕΓΕΙΣ"

/-- Rewrite the main goal left→right with `pf : lhs = rhs`. -/
def rewriteGoal (pf : Expr) : TacticM Unit := withMainContext do
  let goal ← getMainGoal
  let r ← try
    goal.rewrite (← goal.getType) pf false
  catch _ =>
    throwError "ΟΥΔΕΝ ΠΡΟΣ ΕΠΟΣ ΛΕΓΕΙΣ"
  let goal' ← goal.replaceTargetEq r.eNew r.eqProof
  replaceMainGoal (goal' :: r.mvarIds)

def machineEchoGoal (pre : String) : TacticM Unit := do
  withMainContext do logInfo m!"{pre}{← getMainTarget}"

/-! ### Leading-keyword workaround

The `tactic` category has `LeadingIdentBehavior.symbol`, so the FIRST atom
of a tactic rule is compiled as `nonReservedSymbol`: it must match a single
identifier token. ΕΠΕΙ, ΕΣΤΩ, ΥΠΟΚΕΙΤΑΙ contain Π/Σ, which are not
identifier characters, so they can never match that way. Wrapping each
leading keyword in its own syntax category makes it an ordinary token
(registered in the trie, matched by longest-prefix) and sidesteps the
special case. -/

declare_syntax_cat epeiKw
syntax "ΕΠΕΙ " : epeiKw
declare_syntax_cat hupokeitaiKw
syntax "ΥΠΟΚΕΙΤΑΙ " : hupokeitaiKw
declare_syntax_cat estoKw
syntax "ΕΣΤΩ " : estoKw

/-! ### ΕΠΕΙ -/

syntax (name := epei) epeiKw isotes (" ΩΣ " "ΕΔΕΙΧΘΗ")? ", " : tactic

@[tactic epei] def evalEpei : Tactic := fun stx => do
  let prop ← elabSentence (← liftMacroM <| isotesToTerm stx[1])
  let pf ← proveByHoroi prop
  rewriteGoal pf
  machineEchoGoal "ΤΟΥΤΕΣΤΙ ΔΕΙΚΤΕΟΝ ΟΤΙ "

/-! ### ΥΠΟΚΕΙΤΑΙ ΔΕ -/

syntax (name := hupokeitai) hupokeitaiKw "ΔΕ " accInf : tactic

@[tactic hupokeitai] def evalHupokeitai : Tactic := fun stx => do
  let (t, subj, adj) ← liftMacroM <| accInfToTerm stx[2]
  checkAccAgreement subj adj
  let prop ← elabSentence t
  let pf ← withMainContext do
    let mut found := none
    for h in ← getLCtx do
      unless h.isImplementationDetail do
        if ← withReducible <| isDefEq h.type prop then
          found := some h.toExpr
          break
    match found with
    | some pf => pure pf
    | none => throwError "ΟΥ ΤΟΥΤΟ ΥΠΟΚΕΙΤΑΙ"
  rewriteGoal pf
  machineEchoGoal "ΤΟΥΤΕΣΤΙ ΔΕΙΚΤΕΟΝ ΟΤΙ "

/-! ### Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ — the rfl move -/

/-- Gender of the goal subject's head, for the pronoun agreement check. -/
def goalSubjectGender : TacticM Char := withMainContext do
  let tgt ← getMainTarget
  unless tgt.isAppOfArity ``Eq 3 do throwError "ΑΣΑΦΕΣ ΛΕΓΕΙΣ"
  let lhs := tgt.appFn!.appArg!
  if lhs.isConstOf ``Arithmos.ouden then return 'n'
  else if lhs.isConstOf ``Arithmos.monas || lhs.isConstOf ``Arithmos.dyas
       || lhs.isConstOf ``Arithmos.trias || lhs.isConstOf ``Arithmos.tetras then
    return 'f'
  else return 'm'

def closeByTauton (gender : Char) : TacticM Unit := do
  let g ← goalSubjectGender
  unless g == gender do throwError "ΑΣΑΦΕΣ ΛΕΓΕΙΣ"
  let goal ← getMainGoal
  try
    goal.refl
  catch _ =>
    throwError "ΟΥ ΤΑΥΤΟΝ ΛΕΓΕΙΣ"
  replaceMainGoal []
  if (← getGoals).isEmpty then
    logInfo "ΤΑΥΤΟΝ ΛΕΓΕΙΣ· ΟΠΕΡ ΕΔΕΙ ΔΕΙΞΑΙ"
  else
    logInfo "ΤΑΥΤΟΝ ΛΕΓΕΙΣ· ΛΟΙΠΟΝ ΔΗ ΔΕΙΚΤΕΟΝ ΤΟ ΕΤΕΡΟΝ"
    machineEchoGoal "ΔΕΙΚΤΕΟΝ ΟΤΙ "

syntax (name := autosGar) "Ο " "ΑΥΤΟΣ " "ΓΑΡ " estin : tactic
syntax (name := auteGar) "Η " "ΑΥΤΗ " "ΓΑΡ " estin : tactic
syntax (name := autoGar) "ΤΟ " "ΑΥΤΟ " "ΓΑΡ " estin : tactic

@[tactic autosGar] def evalAutosGar : Tactic := fun _ => closeByTauton 'm'
@[tactic auteGar] def evalAuteGar : Tactic := fun _ => closeByTauton 'f'
@[tactic autoGar] def evalAutoGar : Tactic := fun _ => closeByTauton 'n'

/-! ### ἐπαγωγή — the three-sentence protocol -/

syntax (name := epagogeDichotomy)
  "Ο " ident " ΗΤΟΙ " "ΤΟ " "ΟΥΔΕΝ " estin " Η " "ΕΦΕΞΗΣ " "ΤΙΝΟΣ" : tactic

@[tactic epagogeDichotomy] def evalDichotomy : Tactic := fun stx => do
  let x : TSyntax `ident := ⟨stx[1]⟩
  evalTactic (← `(tactic| induction $x:ident))
  logInfo "ΔΥΟ ΔΗ ΔΕΙΚΤΕΑ ΕΣΤΙΝ"

/-- Does the main goal belong to the given constructor's case? -/
def checkCase (suffix : String) : TacticM Unit := do
  let tag ← (← getMainGoal).getTag
  unless (tag.toString.splitOn ".").contains suffix do
    throwError "ΑΣΑΦΕΣ ΛΕΓΕΙΣ"

syntax (name := epagogeBase) estoKw "ΠΡΟΤΕΡΟΝ " "ΤΟ " "ΟΥΔΕΝ" : tactic

@[tactic epagogeBase] def evalBase : Tactic := fun _ => do
  checkCase "ouden"
  machineEchoGoal "ΔΕΙΚΤΕΟΝ ΟΤΙ "

syntax (name := epagogeStep)
  estoKw "ΔΗ " "Ο " ident " ΕΦΕΞΗΣ " "ΑΡΙΘΜΟΥ " "ΤΙΝΟΣ " "ΤΟΥ " ident
  " ΚΑΙ " "ΥΠΟΚΕΙΣΘΩ " accInf : tactic

@[tactic epagogeStep] def evalStep : Tactic := fun stx => do
  checkCase "ephexes"
  let d : TSyntax `ident := ⟨stx[8]⟩
  let h := mkIdent (Name.mkSimple "ΘΕΜΑ")
  evalTactic (← `(tactic| rename_i $d:ident $h:ident))
  let (t, subj, adj) ← liftMacroM <| accInfToTerm stx[11]
  checkAccAgreement subj adj
  let prop ← elabSentence t
  withMainContext do
    let some decl := (← getLCtx).findFromUserName? h.getId
      | throwError "ΟΥ ΤΟΥΤΟ ΥΠΟΚΕΙΤΑΙ"
    unless ← withReducible <| isDefEq decl.type prop do
      throwError "ΟΥ ΤΟΥΤΟ ΥΠΟΚΕΙΤΑΙ"
  machineEchoGoal "ΔΕΙΚΤΕΟΝ ΟΤΙ "

end Oed
