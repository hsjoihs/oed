/-
The object language: ℕ à la NNG, recursion on the SECOND argument
(phrasebook T7: dative = inert base = 1st arg; the nominative-added
2nd arg is what the recursion consumes).

Internal names are ASCII because Lean rejects Π and Σ inside identifiers;
the Greek surface lives entirely in syntax atoms (Oed/Grammar.lean).
-/
import Oed.Horos

namespace Oed

inductive Arithmos : Type where
  | ouden : Arithmos
  | ephexes : Arithmos → Arithmos
deriving DecidableEq, Repr

namespace Arithmos

/-- πρόσθεσις: `prosthesis a b = a + b`, recursing on `b`. -/
def prosthesis : Arithmos → Arithmos → Arithmos
  | a, ouden => a
  | a, ephexes b => ephexes (prosthesis a b)

/-- ἡ μονάς -/ def monas : Arithmos := ephexes ouden
/-- ἡ δυάς -/ def dyas : Arithmos := ephexes monas
/-- ἡ τριάς -/ def trias : Arithmos := ephexes dyas
/-- ἡ τετράς -/ def tetras : Arithmos := ephexes trias

/-! ## The ὅροι (definitional givens, all `rfl`)

ὅρος τῆς προσθέσεως, first clause: ἐὰν ἀριθμῷ τινι τὸ οὐδὲν προστεθῇ,
ὁ γενόμενος τῷ ἐξ ἀρχῆς ἴσος ἐστίν. -/
@[horos] theorem horos_prostheseos_a (a : Arithmos) : prosthesis a ouden = a := rfl

/-- ὅρος τῆς προσθέσεως, second clause: ἐὰν ἀριθμῷ τινι ὁ ἑτέρου τινὸς
ἐφεξῆς προστεθῇ, ὁ γενόμενος ἐφεξῆς ἐστι τοῦ ἐξ ἀμφοῖν συγκειμένου. -/
@[horos] theorem horos_prostheseos_b (a b : Arithmos) :
    prosthesis a (ephexes b) = ephexes (prosthesis a b) := rfl

/-- ἡ μονάς ἐστιν ὁ ἐφεξῆς τοῦ οὐδενός. -/
@[horos] theorem horos_monados : monas = ephexes ouden := rfl
/-- ἡ δυάς ἐστιν ὁ ἐφεξῆς τῆς μονάδος. -/
@[horos] theorem horos_dyados : dyas = ephexes monas := rfl
/-- ἡ τριάς ἐστιν ὁ ἐφεξῆς τῆς δυάδος. -/
@[horos] theorem horos_triados : trias = ephexes dyas := rfl
/-- ἡ τετράς ἐστιν ὁ ἐφεξῆς τῆς τριάδος. -/
@[horos] theorem horos_tetrados : tetras = ephexes trias := rfl

end Arithmos

end Oed
