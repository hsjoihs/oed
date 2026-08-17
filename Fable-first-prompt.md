
Lean 4 web tutorial, Natural Number Game, only uses three tactics rw, rfl, induction to cover the whole of Addition World, Multiplication World, and Power World.

That led me to the following idea: building a simple proof assistant where you write tactics in Ancient Greek, based on the style of Euclid's Elements.

Euclid didn't know about mathematical induction, but I believe we can readily persuade Euclid into understanding what it is all about. The hard part is the lack of variables. It's quite easy to do the equational reasoning of converting "two and two added together is equal to four" into "the successor of the successor of the successor of the successor of zero is equal to the successor of the successor of the successor of the successor of zero" and proclaim by Common Notion #1 "Things which equal the same thing also equal one another" (well, strictly speaking, Common Notion #1 is a little different from reflexivity...) that the proof is complete.


I have studied Latin to some extent, having read its reference grammars and for vocabulary I have done flashcards for quite a long time, and I know a little bit about Sanskrit grammar. I have also held strong interest in Proto-Indo-European historical linguistics and don't need transliteration into Latin alphabets when reading Greek aloud, but I don't have much experience in Ancient Greek itself. I need copious guiding; today I have bought a reference grammar, 古典ギリシア語文典, and am willing to read through it.

As for my experience in proof assistants, I learned about Coq thirteen years ago and have recently (~ a year) started using Lean. I have read Lean's language reference, especially on Elaboration and Compilation. I have also read Benjamin C. Pierce's "Types and Programming Languages", and I have friends who are well versed in homotopy type theory and thus I have some exposures to it. Inductive types, coinductive types, terminations and streams have become second nature to it thanks to those friends.

I am quite used to building compilers and interpreters by hand, from scratch, such as making multiple self-hosting subset-of-C compilers, writing up a regex engine (in ~150 lines of Python) that supports capture groups and greedy/non-greedy matching, and designing a zero-cost abstraction over Brainfuck that tries to be readable by cramming in tons of operator overloading in the standard library.

The rest are my memos. Importantly, while the memos that I give you are all in Japanese, I would like our conversation to be held almost entirely in English. That is because you as a language model have been trained massively using English-language materials; your predecessors always provided much deeper insight when I conversed in English. I will not forbid you from occasionally mixing in Japanese phrases, especially when citing what I have written, but I believe you feel most comfortable composing the bulk of our talk in English.

me:
ユークリッド原論では数学的帰納法は使っていません。自然数の降下列の長さが有限であることは『原論』で使われています。
algebra の notation が無いので、「途中式」に rewrite を重ねて示すというよくある実装をしたい場合、『具象構文が古典ギリシャ語の文であるような、木』を画面に表示してそれを変形する、というユーザーインターフェースを作る必要があります
「定理支援証明系を作る」は既知の software engineering 課題なので有限の手間で終わります。上手い具象構文を定めるのは、software engineering かつ philology です

friend:
「自然列の真の降下列であるような有限列の長さは (先頭の値)+1 以下である」の形にするのが一番構成的かな

me:
「構成主義的に言う」を目指す発想は現状要らないと考える。なぜなら：
いま定めなければならないのは、インターフェース（古典ギリシャ語として破綻していない何らかの形式言語を書くと、それが証明になっていてほしい！　という欲望を叶えるための、意味と構文の対応付け）であって、
そのインターフェースをどのようにして「証明支援系と呼ぶに値するもの」に落とし込むかというソフトウェアエンジニアリングの工学的課題ではないから

me:
照応解析こそがミソだなぁ　という気持ちになってきた
まだ英語でしか読んでないけど
読むべきは、Book VII と、そのアラを改良してもうすこし堅牢にした Book V

me: 
ὁ δὴ Δ τὸν Γ ἤτοι μετρεῖ ἢ οὐ μετρεῖ. μετρείτω πρότερον:
...
μὴ μετρείτω δὴ ὁ Δ τὸν Γ:
...

なるほど、場合分けってこう書くのか
https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0085%3Abook%3D7%3Atype%3DProp%3Anumber%3D3

me:
原論を墨守するというよりも、エウクレイデスに natural number game をやらせるためのインターフェースを考えて組み上げた方がおもろい

エウクレイデスに定理支援証明系の偉大さと便利さを説いて説得させるというプロットにするのがよいだろう。