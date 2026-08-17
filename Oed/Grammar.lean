/-
The controlled-Greek term grammar (uppercase, accent-free, spaced).

Design (phrasebook §3, adapted):
- The article belongs to the FILLER, not the frame: each case-category's
  productions begin with the filler's own article (ΤΟΥ Α / ΤΗΣ ΔΥΑΔΟΣ /
  ΤΟΥ ΟΥΔΕΝΟΣ), so gender agreement is enforced by the parser itself.
- Embedded sums (genitive position) are SANDWICH-ONLY: the closing
  participle ΣΥΓΚΕΙΜΕΝΟΥ is the closing bracket, which keeps the grammar
  unambiguous with no parentheses. Clause-top positions (nom/dat/acc)
  also admit head-first order.
- ΤΕ optionally marks the first conjunct of an outer pair (mandatory in
  print when a conjunct is itself a sum; the parser is permissive).
- Reserved letters: Ο (masc. article = zero glyph collision) and Η
  (fem. article / disjunction) must not be used as variables.
-/
import Oed.Arithmos

namespace Oed

open Lean

declare_syntax_cat arithNomM  -- masculine nominative: variables, ΕΦΕΞΗΣ, ΣΥΓΚΕΙΜΕΝΟΣ
declare_syntax_cat arithNomF  -- feminine nominative: the -ΑΣ numerals
declare_syntax_cat arithNomN  -- neuter nominative: ΤΟ ΟΥΔΕΝ
declare_syntax_cat arithGen   -- genitive descriptions (embedded positions)
declare_syntax_cat arithDat   -- dative descriptions (after ΙΣΟΣ ΕΣΤΙΝ)
declare_syntax_cat arithAcc   -- accusative descriptions (acc. + inf.)
declare_syntax_cat estin      -- movable-ν copula
declare_syntax_cat isotes     -- the equality sentence

syntax "ΕΣΤΙ " : estin
syntax "ΕΣΤΙΝ " : estin

/-! ### Genitive -/
syntax "ΤΟΥ " ident : arithGen
syntax "ΤΟΥ " "ΟΥΔΕΝΟΣ " : arithGen
syntax "ΤΗΣ " "ΜΟΝΑΔΟΣ " : arithGen
syntax "ΤΗΣ " "ΔΥΑΔΟΣ " : arithGen
syntax "ΤΗΣ " "ΤΡΙΑΔΟΣ " : arithGen
syntax "ΤΗΣ " "ΤΕΤΡΑΔΟΣ " : arithGen
syntax "ΤΟΥ " "ΕΦΕΞΗΣ " arithGen : arithGen
-- embedded sum: sandwich only
syntax "ΤΟΥ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen " ΣΥΓΚΕΙΜΕΝΟΥ " : arithGen
-- pair shortcut for two letter-atoms: ΤΟΥ ΕΚ ΤΩΝ Α, Β ΣΥΓΚΕΙΜΕΝΟΥ
syntax "ΤΟΥ " "ΕΚ " "ΤΩΝ " ident ", " ident " ΣΥΓΚΕΙΜΕΝΟΥ " : arithGen

/-! ### Nominative -/
syntax "Ο " ident : arithNomM
syntax "Ο " "ΕΦΕΞΗΣ " arithGen : arithNomM
syntax "Ο " " ΣΥΓΚΕΙΜΕΝΟΣ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen : arithNomM
syntax "Ο " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen " ΣΥΓΚΕΙΜΕΝΟΣ " : arithNomM
syntax "Ο " " ΣΥΓΚΕΙΜΕΝΟΣ " "ΕΚ " "ΤΩΝ " ident ", " ident : arithNomM
syntax "Ο " "ΕΚ " "ΤΩΝ " ident ", " ident " ΣΥΓΚΕΙΜΕΝΟΣ " : arithNomM
syntax "Η " "ΜΟΝΑΣ " : arithNomF
syntax "Η " "ΔΥΑΣ " : arithNomF
syntax "Η " "ΤΡΙΑΣ " : arithNomF
syntax "Η " "ΤΕΤΡΑΣ " : arithNomF
syntax "ΤΟ " "ΟΥΔΕΝ " : arithNomN

/-! ### Dative -/
syntax "ΤΩ " ident : arithDat
syntax "ΤΩ " "ΟΥΔΕΝΙ " : arithDat
syntax "ΤΗ " "ΜΟΝΑΔΙ " : arithDat
syntax "ΤΗ " "ΔΥΑΔΙ " : arithDat
syntax "ΤΗ " "ΤΡΙΑΔΙ " : arithDat
syntax "ΤΗ " "ΤΕΤΡΑΔΙ " : arithDat
syntax "ΤΩ " "ΕΦΕΞΗΣ " arithGen : arithDat
syntax "ΤΩ " " ΣΥΓΚΕΙΜΕΝΩ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen : arithDat
syntax "ΤΩ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen " ΣΥΓΚΕΙΜΕΝΩ " : arithDat
syntax "ΤΩ " " ΣΥΓΚΕΙΜΕΝΩ " "ΕΚ " "ΤΩΝ " ident ", " ident : arithDat
syntax "ΤΩ " "ΕΚ " "ΤΩΝ " ident ", " ident " ΣΥΓΚΕΙΜΕΝΩ " : arithDat

/-! ### Accusative -/
syntax "ΤΟΝ " ident : arithAcc
syntax "ΤΟ " "ΟΥΔΕΝ " : arithAcc
syntax "ΤΗΝ " "ΜΟΝΑΔΑ " : arithAcc
syntax "ΤΗΝ " "ΔΥΑΔΑ " : arithAcc
syntax "ΤΗΝ " "ΤΡΙΑΔΑ " : arithAcc
syntax "ΤΗΝ " "ΤΕΤΡΑΔΑ " : arithAcc
syntax "ΤΟΝ " "ΕΦΕΞΗΣ " arithGen : arithAcc
syntax "ΤΟΝ " " ΣΥΓΚΕΙΜΕΝΟΝ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen : arithAcc
syntax "ΤΟΝ " "ΕΚ " "ΤΕ "? arithGen " ΚΑΙ " arithGen " ΣΥΓΚΕΙΜΕΝΟΝ " : arithAcc
syntax "ΤΟΝ " " ΣΥΓΚΕΙΜΕΝΟΝ " "ΕΚ " "ΤΩΝ " ident ", " ident : arithAcc
syntax "ΤΟΝ " "ΕΚ " "ΤΩΝ " ident ", " ident " ΣΥΓΚΕΙΜΕΝΟΝ " : arithAcc

/-! ### The equality sentence — ΙΣΟΣ agrees with the subject's gender -/
syntax arithNomM " ΙΣΟΣ " estin arithDat : isotes
syntax arithNomF " ΙΣΗ " estin arithDat : isotes
syntax arithNomN " ΙΣΟΝ " estin arithDat : isotes

/-! ### Elaboration: each category linearizes a plain `Arithmos` term -/

open Arithmos in
partial def genToTerm : Syntax → MacroM (TSyntax `term)
  | `(arithGen| ΤΟΥ $x:ident) => pure x
  | `(arithGen| ΤΟΥ ΟΥΔΕΝΟΣ) => `(Arithmos.ouden)
  | `(arithGen| ΤΗΣ ΜΟΝΑΔΟΣ) => `(Arithmos.monas)
  | `(arithGen| ΤΗΣ ΔΥΑΔΟΣ) => `(Arithmos.dyas)
  | `(arithGen| ΤΗΣ ΤΡΙΑΔΟΣ) => `(Arithmos.trias)
  | `(arithGen| ΤΗΣ ΤΕΤΡΑΔΟΣ) => `(Arithmos.tetras)
  | `(arithGen| ΤΟΥ ΕΦΕΞΗΣ $g:arithGen) => do
      `(Arithmos.ephexes $(← genToTerm g))
  | `(arithGen| ΤΟΥ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen ΣΥΓΚΕΙΜΕΝΟΥ) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithGen| ΤΟΥ ΕΚ ΤΩΝ $x:ident , $y:ident ΣΥΓΚΕΙΜΕΝΟΥ) =>
      `(Arithmos.prosthesis $x $y)
  | _ => Macro.throwUnsupported

open Arithmos in
partial def nomToTerm : Syntax → MacroM (TSyntax `term)
  | `(arithNomM| Ο $x:ident) => pure x
  | `(arithNomM| Ο ΕΦΕΞΗΣ $g:arithGen) => do
      `(Arithmos.ephexes $(← genToTerm g))
  | `(arithNomM| Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithNomM| Ο ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen ΣΥΓΚΕΙΜΕΝΟΣ) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithNomM| Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ ΤΩΝ $x:ident , $y:ident) =>
      `(Arithmos.prosthesis $x $y)
  | `(arithNomM| Ο ΕΚ ΤΩΝ $x:ident , $y:ident ΣΥΓΚΕΙΜΕΝΟΣ) =>
      `(Arithmos.prosthesis $x $y)
  | `(arithNomF| Η ΜΟΝΑΣ) => `(Arithmos.monas)
  | `(arithNomF| Η ΔΥΑΣ) => `(Arithmos.dyas)
  | `(arithNomF| Η ΤΡΙΑΣ) => `(Arithmos.trias)
  | `(arithNomF| Η ΤΕΤΡΑΣ) => `(Arithmos.tetras)
  | `(arithNomN| ΤΟ ΟΥΔΕΝ) => `(Arithmos.ouden)
  | _ => Macro.throwUnsupported

open Arithmos in
partial def datToTerm : Syntax → MacroM (TSyntax `term)
  | `(arithDat| ΤΩ $x:ident) => pure x
  | `(arithDat| ΤΩ ΟΥΔΕΝΙ) => `(Arithmos.ouden)
  | `(arithDat| ΤΗ ΜΟΝΑΔΙ) => `(Arithmos.monas)
  | `(arithDat| ΤΗ ΔΥΑΔΙ) => `(Arithmos.dyas)
  | `(arithDat| ΤΗ ΤΡΙΑΔΙ) => `(Arithmos.trias)
  | `(arithDat| ΤΗ ΤΕΤΡΑΔΙ) => `(Arithmos.tetras)
  | `(arithDat| ΤΩ ΕΦΕΞΗΣ $g:arithGen) => do
      `(Arithmos.ephexes $(← genToTerm g))
  | `(arithDat| ΤΩ ΣΥΓΚΕΙΜΕΝΩ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithDat| ΤΩ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen ΣΥΓΚΕΙΜΕΝΩ) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithDat| ΤΩ ΣΥΓΚΕΙΜΕΝΩ ΕΚ ΤΩΝ $x:ident , $y:ident) =>
      `(Arithmos.prosthesis $x $y)
  | `(arithDat| ΤΩ ΕΚ ΤΩΝ $x:ident , $y:ident ΣΥΓΚΕΙΜΕΝΩ) =>
      `(Arithmos.prosthesis $x $y)
  | _ => Macro.throwUnsupported

open Arithmos in
partial def accToTerm : Syntax → MacroM (TSyntax `term)
  | `(arithAcc| ΤΟΝ $x:ident) => pure x
  | `(arithAcc| ΤΟ ΟΥΔΕΝ) => `(Arithmos.ouden)
  | `(arithAcc| ΤΗΝ ΜΟΝΑΔΑ) => `(Arithmos.monas)
  | `(arithAcc| ΤΗΝ ΔΥΑΔΑ) => `(Arithmos.dyas)
  | `(arithAcc| ΤΗΝ ΤΡΙΑΔΑ) => `(Arithmos.trias)
  | `(arithAcc| ΤΗΝ ΤΕΤΡΑΔΑ) => `(Arithmos.tetras)
  | `(arithAcc| ΤΟΝ ΕΦΕΞΗΣ $g:arithGen) => do
      `(Arithmos.ephexes $(← genToTerm g))
  | `(arithAcc| ΤΟΝ ΣΥΓΚΕΙΜΕΝΟΝ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithAcc| ΤΟΝ ΕΚ $[ΤΕ]? $a:arithGen ΚΑΙ $b:arithGen ΣΥΓΚΕΙΜΕΝΟΝ) => do
      `(Arithmos.prosthesis $(← genToTerm a) $(← genToTerm b))
  | `(arithAcc| ΤΟΝ ΣΥΓΚΕΙΜΕΝΟΝ ΕΚ ΤΩΝ $x:ident , $y:ident) =>
      `(Arithmos.prosthesis $x $y)
  | `(arithAcc| ΤΟΝ ΕΚ ΤΩΝ $x:ident , $y:ident ΣΥΓΚΕΙΜΕΝΟΝ) =>
      `(Arithmos.prosthesis $x $y)
  | _ => Macro.throwUnsupported

/-- Expand an equality sentence into `lhs = rhs`. -/
def isotesToTerm : Syntax → MacroM (TSyntax `term)
  | `(isotes| $s:arithNomM ΙΣΟΣ $_:estin $d:arithDat) => do
      `($(← nomToTerm s) = $(← datToTerm d))
  | `(isotes| $s:arithNomF ΙΣΗ $_:estin $d:arithDat) => do
      `($(← nomToTerm s) = $(← datToTerm d))
  | `(isotes| $s:arithNomN ΙΣΟΝ $_:estin $d:arithDat) => do
      `($(← nomToTerm s) = $(← datToTerm d))
  | _ => Macro.throwUnsupported

/-- An equality sentence is a term (a `Prop`). -/
syntax (name := isotesAsTerm) isotes : term

macro_rules
  | `(term| $s:isotes) => isotesToTerm s

end Oed
