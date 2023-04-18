#lang scribble/manual

@title["Foo"]
@author["Shawn"]
@section{markdown-to-scribble}
Convert markdown text to Scribble markup.

Some samples for testing:

@itemlist[#:style #f
@item{@para{a}
}
@item{@para{bullet}
}
@item{@para{list with code @tt["(+ 1 2)"] and @italic{markup}}
}
]
and

@itemlist[#:style 'ordered
@item{@para{a}
}
@item{@para{numbered}
}
@item{@para{list with code @tt["@linebreak"] and @bold{markup}}
}
]
@subsection{a subsection}
@nested[#:style 'code-inset]{@verbatim["a code block\n(+ 1 2)\n"]}

@subsubsection{and deeper subsubsection}
some text with @hyperlink["https://racket-lang.org"]{a link} in it.

@nested[#:style 'inset]{
a block
quote
of text

}

Some text with @"@"bold@"{"scribble@"}" markup that shouldn't be parsed.

and a second paragraph immediately following.

@subsubsub*section{A level-4 heading}
@codeblock|{
; a fenced code block of scheme
(+ 1 2 3)
}|

and one of racket

@codeblock|{
(require racket/vector)
(define (do-some-stuff)
  #t)
}|

these test different renderings for the scribble/manual lang.

