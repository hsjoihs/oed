/-
Greek goal display: a delaborator that re-linearizes any
`lhs = rhs` (at type Arithmos) as the uppercase equality sentence.

This is phrasebook §1.1 happening inside Lean's own pretty-printer:
rewriting acts on the Expr tree and the article of every filler is
recomputed from its case-position and gender on each display, so a
rewrite that replaces Η ΔΥΑΣ by Ο ΕΦΕΞΗΣ ΤΗΣ ΜΟΝΑΔΟΣ inside a genitive
slot flips ΤΗΣ → ΤΟΥ automatically.

Linearization rules (phrasebook §3.2, pretty-printer note):
- clause-top sums (nominative subject, dative RHS) print head-first;
- embedded sums (genitive) print sandwich, participle = closing bracket;
- ΤΕ marks the outer pair when a conjunct is itself a sum.
-/
import Oed.Grammar

namespace Oed

open Lean Meta PrettyPrinter Delaborator SubExpr

/-- The subject's syntax together with its gender (which selects ΙΣΟΣ/ΙΣΗ/ΙΣΟΝ). -/
private inductive NomStx where
  | m (s : TSyntax `arithNomM)
  | f (s : TSyntax `arithNomF)
  | n (s : TSyntax `arithNomN)

private def isSum (e : Expr) : Bool :=
  e.isAppOfArity ``Arithmos.prosthesis 2

/-- Genitive linearization (embedded positions; sums are sandwich-only). -/
private partial def toGen (e : Expr) : DelabM (TSyntax `arithGen) := do
  match e with
  | .fvar id => let n ← id.getUserName; `(arithGen| ΤΟΥ $(mkIdent n):ident)
  | .const ``Arithmos.ouden _ => `(arithGen| ΤΟΥ ΟΥΔΕΝΟΣ)
  | .const ``Arithmos.monas _ => `(arithGen| ΤΗΣ ΜΟΝΑΔΟΣ)
  | .const ``Arithmos.dyas _ => `(arithGen| ΤΗΣ ΔΥΑΔΟΣ)
  | .const ``Arithmos.trias _ => `(arithGen| ΤΗΣ ΤΡΙΑΔΟΣ)
  | .const ``Arithmos.tetras _ => `(arithGen| ΤΗΣ ΤΕΤΡΑΔΟΣ)
  | _ =>
    if e.isAppOfArity ``Arithmos.ephexes 1 then
      `(arithGen| ΤΟΥ ΕΦΕΞΗΣ $(← toGen e.appArg!))
    else if isSum e then
      let a := e.appFn!.appArg!
      let b := e.appArg!
      let ga ← toGen a
      let gb ← toGen b
      if isSum a || isSum b then
        `(arithGen| ΤΟΥ ΕΚ ΤΕ $ga ΚΑΙ $gb ΣΥΓΚΕΙΜΕΝΟΥ)
      else
        `(arithGen| ΤΟΥ ΕΚ $ga ΚΑΙ $gb ΣΥΓΚΕΙΜΕΝΟΥ)
    else failure

/-- Nominative linearization (clause-top; sums head-first). -/
private partial def toNom (e : Expr) : DelabM NomStx := do
  match e with
  | .fvar id =>
      let n ← id.getUserName
      return .m (← `(arithNomM| Ο $(mkIdent n):ident))
  | .const ``Arithmos.ouden _ => return .n (← `(arithNomN| ΤΟ ΟΥΔΕΝ))
  | .const ``Arithmos.monas _ => return .f (← `(arithNomF| Η ΜΟΝΑΣ))
  | .const ``Arithmos.dyas _ => return .f (← `(arithNomF| Η ΔΥΑΣ))
  | .const ``Arithmos.trias _ => return .f (← `(arithNomF| Η ΤΡΙΑΣ))
  | .const ``Arithmos.tetras _ => return .f (← `(arithNomF| Η ΤΕΤΡΑΣ))
  | _ =>
    if e.isAppOfArity ``Arithmos.ephexes 1 then
      return .m (← `(arithNomM| Ο ΕΦΕΞΗΣ $(← toGen e.appArg!)))
    else if isSum e then
      let a := e.appFn!.appArg!
      let b := e.appArg!
      let ga ← toGen a
      let gb ← toGen b
      if isSum a || isSum b then
        return .m (← `(arithNomM| Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ ΤΕ $ga ΚΑΙ $gb))
      else
        return .m (← `(arithNomM| Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ $ga ΚΑΙ $gb))
    else failure

/-- Dative linearization (clause-final; sums head-first). -/
private partial def toDat (e : Expr) : DelabM (TSyntax `arithDat) := do
  match e with
  | .fvar id => let n ← id.getUserName; `(arithDat| ΤΩ $(mkIdent n):ident)
  | .const ``Arithmos.ouden _ => `(arithDat| ΤΩ ΟΥΔΕΝΙ)
  | .const ``Arithmos.monas _ => `(arithDat| ΤΗ ΜΟΝΑΔΙ)
  | .const ``Arithmos.dyas _ => `(arithDat| ΤΗ ΔΥΑΔΙ)
  | .const ``Arithmos.trias _ => `(arithDat| ΤΗ ΤΡΙΑΔΙ)
  | .const ``Arithmos.tetras _ => `(arithDat| ΤΗ ΤΕΤΡΑΔΙ)
  | _ =>
    if e.isAppOfArity ``Arithmos.ephexes 1 then
      `(arithDat| ΤΩ ΕΦΕΞΗΣ $(← toGen e.appArg!))
    else if isSum e then
      let a := e.appFn!.appArg!
      let b := e.appArg!
      let ga ← toGen a
      let gb ← toGen b
      if isSum a || isSum b then
        `(arithDat| ΤΩ ΣΥΓΚΕΙΜΕΝΩ ΕΚ ΤΕ $ga ΚΑΙ $gb)
      else
        `(arithDat| ΤΩ ΣΥΓΚΕΙΜΕΝΩ ΕΚ $ga ΚΑΙ $gb)
    else failure

/-- Accusative linearization (for the acc.+inf. frames). -/
partial def toAcc (e : Expr) : DelabM (TSyntax `arithAcc) := do
  match e with
  | .fvar id => let n ← id.getUserName; `(arithAcc| ΤΟΝ $(mkIdent n):ident)
  | .const ``Arithmos.ouden _ => `(arithAcc| ΤΟ ΟΥΔΕΝ)
  | .const ``Arithmos.monas _ => `(arithAcc| ΤΗΝ ΜΟΝΑΔΑ)
  | .const ``Arithmos.dyas _ => `(arithAcc| ΤΗΝ ΔΥΑΔΑ)
  | .const ``Arithmos.trias _ => `(arithAcc| ΤΗΝ ΤΡΙΑΔΑ)
  | .const ``Arithmos.tetras _ => `(arithAcc| ΤΗΝ ΤΕΤΡΑΔΑ)
  | _ =>
    if e.isAppOfArity ``Arithmos.ephexes 1 then
      `(arithAcc| ΤΟΝ ΕΦΕΞΗΣ $(← toGen e.appArg!))
    else if isSum e then
      let a := e.appFn!.appArg!
      let b := e.appArg!
      let ga ← toGen a
      let gb ← toGen b
      if isSum a || isSum b then
        `(arithAcc| ΤΟΝ ΣΥΓΚΕΙΜΕΝΟΝ ΕΚ ΤΕ $ga ΚΑΙ $gb)
      else
        `(arithAcc| ΤΟΝ ΣΥΓΚΕΙΜΕΝΟΝ ΕΚ $ga ΚΑΙ $gb)
    else failure

/-- Linearize `lhs = rhs` (at Arithmos) as the full sentence, ΙΣΟΣ agreeing
with the subject's gender. Movable ν: we always print ΕΣΤΙΝ (v0 deviation). -/
def eqToIsotes (lhs rhs : Expr) : DelabM (TSyntax `isotes) := do
  let d ← toDat rhs
  match ← toNom lhs with
  | .m s => `(isotes| $s:arithNomM ΙΣΟΣ ΕΣΤΙΝ $d:arithDat)
  | .f s => `(isotes| $s:arithNomF ΙΣΗ ΕΣΤΙΝ $d:arithDat)
  | .n s => `(isotes| $s:arithNomN ΙΣΟΝ ΕΣΤΙΝ $d:arithDat)

@[delab app.Eq]
def delabIsotes : Delab := do
  let e ← getExpr
  guard <| e.isAppOfArity ``Eq 3
  let ty := e.appFn!.appFn!.appArg!
  guard <| ty.isConstOf ``Arithmos
  let s ← eqToIsotes e.appFn!.appArg! e.appArg!
  return ⟨mkNode ``isotesAsTerm #[s.raw]⟩

/-- Hypothesis/type display: `Α : ΑΡΙΘΜΟΣ`. -/
notation "ΑΡΙΘΜΟΣ" => Arithmos

end Oed
