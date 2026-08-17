/- ἔλεγχος — negative tests: the machine must refuse these.

Parse-level agreement violations (wrong article or adjective gender,
e.g. Η ΔΥΑΣ ΙΣΟΣ … or ΕΚ ΤΟΥ ΔΥΑΔΟΣ) never reach elaboration: there is
no production for them, which is the point of parser-enforced concord.
The cases below are the elaboration-level refusals. -/
import Levels.AddAssoc
open Oed Oed.Arithmos

-- citing an equation not granted by any ὅρος: ΑΣΑΦΕΣ ΛΕΓΕΙΣ
-- (2 = 4 is false, but even a TRUE uncited equation would be refused)
example : prosthesis dyas dyas = tetras := by
  fail_if_success ΕΠΕΙ Η ΔΥΑΣ ΙΣΗ ΕΣΤΙΝ ΤΗ ΤΕΤΡΑΔΙ,
  Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ

-- true and provable, but not a ὅρος restatement: also ΑΣΑΦΕΣ ΛΕΓΕΙΣ
-- (the free logic budget: defeq facts are not citable, only ὅροι are)
example : prosthesis dyas dyas = tetras := by
  fail_if_success ΕΠΕΙ Η ΤΕΤΡΑΣ ΙΣΗ ΕΣΤΙΝ ΤΩ ΕΦΕΞΗΣ ΤΟΥ ΕΦΕΞΗΣ ΤΗΣ ΔΥΑΔΟΣ,
  Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ

-- wrong-gender pronoun for a feminine subject, then the correct one
example : dyas = ephexes monas := by
  fail_if_success Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ
  Η ΑΥΤΗ ΓΑΡ ΕΣΤΙ

-- ΥΠΟΚΕΙΣΘΩ stating a wrong induction hypothesis: ΟΥ ΤΟΥΤΟ ΥΠΟΚΕΙΤΑΙ
example (Α : ΑΡΙΘΜΟΣ) : prosthesis ouden Α = Α := by
  Ο Α ΗΤΟΙ ΤΟ ΟΥΔΕΝ ΕΣΤΙΝ Η ΕΦΕΞΗΣ ΤΙΝΟΣ
  ΕΣΤΩ ΠΡΟΤΕΡΟΝ ΤΟ ΟΥΔΕΝ
  Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ
  fail_if_success ΕΣΤΩ ΔΗ Ο Α ΕΦΕΞΗΣ ΑΡΙΘΜΟΥ ΤΙΝΟΣ ΤΟΥ Δ ΚΑΙ ΥΠΟΚΕΙΣΘΩ ΤΗΝ ΔΥΑΔΑ ΙΣΗΝ ΕΙΝΑΙ ΤΗ ΔΥΑΔΙ
  ΕΣΤΩ ΔΗ Ο Α ΕΦΕΞΗΣ ΑΡΙΘΜΟΥ ΤΙΝΟΣ ΤΟΥ Δ ΚΑΙ ΥΠΟΚΕΙΣΘΩ ΤΟΝ ΕΚ ΤΟΥ ΟΥΔΕΝΟΣ ΚΑΙ ΤΟΥ Δ ΣΥΓΚΕΙΜΕΝΟΝ ΙΣΟΝ ΕΙΝΑΙ ΤΩ Δ
  ΕΠΕΙ Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ ΤΟΥ ΟΥΔΕΝΟΣ ΚΑΙ ΤΟΥ ΕΦΕΞΗΣ ΤΟΥ Δ ΙΣΟΣ ΕΣΤΙΝ ΤΩ ΕΦΕΞΗΣ ΤΟΥ ΕΚ ΤΟΥ ΟΥΔΕΝΟΣ ΚΑΙ ΤΟΥ Δ ΣΥΓΚΕΙΜΕΝΟΥ,
  ΥΠΟΚΕΙΤΑΙ ΔΕ ΤΟΝ ΕΚ ΤΟΥ ΟΥΔΕΝΟΣ ΚΑΙ ΤΟΥ Δ ΣΥΓΚΕΙΜΕΝΟΝ ΙΣΟΝ ΕΙΝΑΙ ΤΩ Δ
  Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ

-- the base branch must come first: entering the step out of order fails
example (Α : ΑΡΙΘΜΟΣ) : prosthesis Α ouden = Α := by
  Ο Α ΗΤΟΙ ΤΟ ΟΥΔΕΝ ΕΣΤΙΝ Η ΕΦΕΞΗΣ ΤΙΝΟΣ
  fail_if_success ΕΣΤΩ ΔΗ Ο Α ΕΦΕΞΗΣ ΑΡΙΘΜΟΥ ΤΙΝΟΣ ΤΟΥ Δ ΚΑΙ ΥΠΟΚΕΙΣΘΩ ΤΟΝ ΕΚ ΤΟΥ Δ ΚΑΙ ΤΟΥ ΟΥΔΕΝΟΣ ΣΥΓΚΕΙΜΕΝΟΝ ΙΣΟΝ ΕΙΝΑΙ ΤΩ Δ
  ΕΣΤΩ ΠΡΟΤΕΡΟΝ ΤΟ ΟΥΔΕΝ
  ΕΠΕΙ Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ ΤΟΥ ΟΥΔΕΝΟΣ ΚΑΙ ΤΟΥ ΟΥΔΕΝΟΣ ΙΣΟΣ ΕΣΤΙΝ ΤΩ ΟΥΔΕΝΙ,
  ΤΟ ΑΥΤΟ ΓΑΡ ΕΣΤΙ
  ΕΣΤΩ ΔΗ Ο Α ΕΦΕΞΗΣ ΑΡΙΘΜΟΥ ΤΙΝΟΣ ΤΟΥ Δ ΚΑΙ ΥΠΟΚΕΙΣΘΩ ΤΟΝ ΕΚ ΤΟΥ Δ ΚΑΙ ΤΟΥ ΟΥΔΕΝΟΣ ΣΥΓΚΕΙΜΕΝΟΝ ΙΣΟΝ ΕΙΝΑΙ ΤΩ Δ
  ΕΠΕΙ Ο ΣΥΓΚΕΙΜΕΝΟΣ ΕΚ ΤΟΥ ΕΦΕΞΗΣ ΤΟΥ Δ ΚΑΙ ΤΟΥ ΟΥΔΕΝΟΣ ΙΣΟΣ ΕΣΤΙΝ ΤΩ ΕΦΕΞΗΣ ΤΟΥ Δ,
  Ο ΑΥΤΟΣ ΓΑΡ ΕΣΤΙ
