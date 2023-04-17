#lang scribble/base

@title{markdown-to-scribble}
@section{markdown-to-scribble}
Convert markdown text to Scribble markup.

Some samples for testing:

@itemlist[#:style #f
@item{@para{a}
}
@item{@para{bullet}
}
@item{@para{list @tt["with code (+ 1 2)"] and @italic{markup}}
}
]
and

@itemlist[#:style 'ordered
@item{@para{a}
}
@item{@para{numbered}
}
@item{@para{list with @tt["code @linebreak"] and @bold{markup}}
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

