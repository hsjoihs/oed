/-
Scripta continua (M6): word division is anachronistic, so let the
teleported mathematician write

    ΣΥΝΕΧΩΣ
    ΠΡΟΤΑΣΙΣ
    ΛΕΓΩΟΤΙΟΣΥΓΚΕΙΜΕΝΟΣΕΚΤΗΣΔΥΑΔΟΣΚΑΙΤΗΣΔΥΑΔΟΣΙΣΟΣΕΣΤΙΤΗΤΕΤΡΑΔΙ
    ...
    ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ

The ΣΥΝΕΧΩΣ command owns everything up to (and including) the line
ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ via a raw ParserFn — the "nontrivial lexer layer" Lean
will not give us any other way. Each line (one sentence per line) is then
word-divided by a backtracking maximal-munch lexer over the closed
lexicon, letter-variables are typed by their spelled-out names
(ΑΛΦΑ ΒΗΤΑ ΓΑΜΜΑ ΔΕΛΤΑ ... → Α Β Γ Δ ...), the asyndetic-pair commas
and ΕΠΕΙ's clause-final comma are restored, and the spaced text is fed
back through the ordinary grammar with `runParserCategory` — the continua
layer is literally a modular lexer bolted in front of the same language.
-/
import Oed.Protasis

namespace Oed

open Lean Parser Elab Command

/-- The closed lexicon: surface word ↦ emitted word. Letter-variables are
spelled out (scriptio continua cannot delimit a bare letter) and map to
their glyphs. -/
def continuaLexicon : List (String × String) :=
  ([ "ΠΡΟΤΑΣΙΣ", "ΛΕΓΩ", "ΟΤΙ", "ΟΠΕΡ", "ΕΔΕΙ", "ΔΕΙΞΑΙ",
     "ΕΣΤΩΣΑΝ", "ΕΣΤΩ", "ΑΡΙΘΜΟΣ", "ΑΡΙΘΜΟΙ", "ΑΡΙΘΜΟΥ", "ΟΙ",
     "ΕΠΕΙ", "ΥΠΟΚΕΙΤΑΙ", "ΥΠΟΚΕΙΣΘΩ", "ΩΣ", "ΕΔΕΙΧΘΗ",
     "ΗΤΟΙ", "ΠΡΟΤΕΡΟΝ", "ΤΙΝΟΣ", "ΔΗ", "ΔΕ", "ΓΑΡ",
     "ΑΥΤΟΣ", "ΑΥΤΗ", "ΑΥΤΟ",
     "Ο", "Η", "ΤΟ", "ΤΟΥ", "ΤΗΣ", "ΤΩ", "ΤΗ", "ΤΟΝ", "ΤΗΝ", "ΤΩΝ",
     "ΟΥΔΕΝ", "ΟΥΔΕΝΟΣ", "ΟΥΔΕΝΙ",
     "ΜΟΝΑΣ", "ΜΟΝΑΔΟΣ", "ΜΟΝΑΔΙ", "ΜΟΝΑΔΑ",
     "ΔΥΑΣ", "ΔΥΑΔΟΣ", "ΔΥΑΔΙ", "ΔΥΑΔΑ",
     "ΤΡΙΑΣ", "ΤΡΙΑΔΟΣ", "ΤΡΙΑΔΙ", "ΤΡΙΑΔΑ",
     "ΤΕΤΡΑΣ", "ΤΕΤΡΑΔΟΣ", "ΤΕΤΡΑΔΙ", "ΤΕΤΡΑΔΑ",
     "ΕΦΕΞΗΣ", "ΕΚ", "ΚΑΙ", "ΤΕ",
     "ΣΥΓΚΕΙΜΕΝΟΣ", "ΣΥΓΚΕΙΜΕΝΟΥ", "ΣΥΓΚΕΙΜΕΝΩ", "ΣΥΓΚΕΙΜΕΝΟΝ",
     "ΙΣΟΣ", "ΙΣΗ", "ΙΣΟΝ", "ΙΣΗΝ",
     "ΕΣΤΙΝ", "ΕΣΤΙ", "ΕΙΝΑΙ" ].map (fun w => (w, w)))
  ++ [ ("ΑΛΦΑ", "Α"), ("ΒΗΤΑ", "Β"), ("ΓΑΜΜΑ", "Γ"), ("ΔΕΛΤΑ", "Δ"),
       ("ΕΨΙΛΟΝ", "Ε"), ("ΖΗΤΑ", "Ζ") ]

/-- Longest words first, so greedy tries the maximal munch before
backtracking to shorter alternatives. -/
private def sortedLexicon : List (String × String) :=
  (continuaLexicon.toArray.qsort (fun a b => a.1.length > b.1.length)).toList

private def variableGlyphs : List String := ["Α", "Β", "Γ", "Δ", "Ε", "Ζ"]

/-- Backtracking maximal-munch word division. -/
partial def lexContinua (s : String) : Option (List String) :=
  if s.isEmpty then some [] else
  let rec tryWords : List (String × String) → Option (List String)
    | [] => none
    | (w, out) :: ws =>
      if w.isPrefixOf s then
        match lexContinua (s.drop w.length).toString with
        | some r => some (out :: r)
        | none => tryWords ws
      else tryWords ws
  tryWords sortedLexicon

/-- Restore what continua drops: the comma of an asyndetic letter pair
(ΤΩΝ Α, Β), and ΕΠΕΙ's clause-final comma. -/
def respace (ws : List String) : String :=
  let rec commas : List String → List String
    | x :: y :: rest =>
      if variableGlyphs.contains x && variableGlyphs.contains y then
        x :: "," :: commas (y :: rest)
      else x :: commas (y :: rest)
    | l => l
  let body := " ".intercalate (commas ws)
  match ws with
  | "ΕΠΕΙ" :: _ => body ++ " ,"
  | _ => body

/-- Raw parser: consume everything through the line ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ and
push it as one atom. This is the layer Lean's own tokenizer cannot be
taught to provide. -/
def continuaBodyFn : ParserFn := fun c s =>
  let startPos := s.pos
  let rest := c.extract startPos c.endPos
  match rest.splitOn "ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ" with
  | before :: _ :: _ =>
    let consumed := before ++ "ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ"
    let stopPos := startPos + consumed
    let s := s.setPos stopPos
    let s := whitespace c s
    s.pushSyntax <| Syntax.atom .none consumed
  | _ => s.mkError "ΟΠΕΡΕΔΕΙΔΕΙΞΑΙ"

def continuaBody : Parser := { fn := continuaBodyFn }

open PrettyPrinter in
@[combinator_formatter continuaBody]
def continuaBody.formatter : Formatter := pure ()
open PrettyPrinter in
@[combinator_parenthesizer continuaBody]
def continuaBody.parenthesizer : Parenthesizer := pure ()

@[command_parser] def sunechos : Parser :=
  leading_parser "ΣΥΝΕΧΩΣ " >> continuaBody

@[command_elab sunechos] def elabSunechos : CommandElab := fun stx => do
  let .atom _ content := stx[1] | throwUnsupportedSyntax
  let lines := content.splitOn "\n" |>.map (·.trimAscii.toString) |>.filter (!·.isEmpty)
  let spaced ← lines.mapM fun l =>
    match lexContinua l with
    | some ws => pure (respace ws)
    | none => throwError s!"ΑΣΑΦΕΣ ΛΕΓΕΙΣ· {l}"
  let text := "\n".intercalate spaced
  match runParserCategory (← getEnv) `command text "ΣΥΝΕΧΩΣ" with
  | .ok cmd => elabCommand cmd
  | .error e => throwError e

end Oed
