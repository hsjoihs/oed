/-
The proposition scaffold (phrasebook §4): a ΠΡΟΤΑΣΙΣ command wrapping
`theorem`, so an entire .lean file after the import line reads as Greek.

    ΠΡΟΤΑΣΙΣ
    ΕΣΤΩ ΑΡΙΘΜΟΣ Ο Α            -- ἔκθεσις (optional; binds the letters)
    ΛΕΓΩ ΟΤΙ <sentence>          -- διορισμός (the lettered goal)
    <tactic sentences>           -- ἀπόδειξις
    ΟΠΕΡ ΕΔΕΙ ΔΕΙΞΑΙ             -- συμπέρασμα (proof must be complete)

The proved proposition is auto-named and tagged @[horos], so later levels
can cite it by restatement (ΩΣ ΕΔΕΙΧΘΗ). The letters of the ἔκθεσις become
signature binders — automatically introduced, which is exactly the
ἔκθεσις-is-intro correspondence.
-/
import Oed.Moves

namespace Oed

open Lean Elab Command Parser.Tactic

declare_syntax_cat ektesis
syntax "ΕΣΤΩ " "ΑΡΙΘΜΟΣ " "Ο " ident : ektesis
syntax "ΕΣΤΩΣΑΝ " "ΑΡΙΘΜΟΙ " "ΟΙ " ident,+ : ektesis

def ektesisVars : Syntax → CommandElabM (Array Ident)
  | `(ektesis| ΕΣΤΩ ΑΡΙΘΜΟΣ Ο $x:ident) => return #[x]
  | `(ektesis| ΕΣΤΩΣΑΝ ΑΡΙΘΜΟΙ ΟΙ $xs:ident,*) => return xs.getElems
  | _ => throwUnsupportedSyntax

syntax (name := protasis)
  "ΠΡΟΤΑΣΙΣ " (ektesis)? "ΛΕΓΩ " "ΟΤΙ " isotes
  tacticSeq
  "ΟΠΕΡ " "ΕΔΕΙ " "ΔΕΙΞΑΙ" : command

/-- Fresh `protasis_<i>` name in the current namespace. -/
partial def freshProtasisName (i : Nat := 1) : CommandElabM Name := do
  let ns := (← getScope).currNamespace
  let n := Name.mkSimple s!"protasis_{i}"
  if (← getEnv).contains (ns ++ n) then freshProtasisName (i + 1) else return n

elab_rules : command
  | `(ΠΡΟΤΑΣΙΣ $[$ek:ektesis]? ΛΕΓΩ ΟΤΙ $s:isotes
      $tacs:tacticSeq
      ΟΠΕΡ ΕΔΕΙ ΔΕΙΞΑΙ) => do
    let vars ← match ek with
      | some e => ektesisVars e
      | none => pure #[]
    let prop ← liftMacroM <| isotesToTerm s
    let name := mkIdent (← freshProtasisName)
    elabCommand <| ←
      `(@[horos] theorem $name $[($vars:ident : ΑΡΙΘΜΟΣ)]* : $prop := by
          $tacs)

end Oed
