#lang scribble/manual
@require[@for-label[commonmark/render/scribble
                    racket/base commonmark/struct]]

@title{Markdown To Scribble}
@author[(author+email "Shawn Wagner" "shawnw.mobile@gmail.com")]

Convert markdown into scribble document format. Most @hyperlink["https://commonmark.org/"]{CommonMark} elements are supported, except for html blocks and inline html.

@section{API}

@defmodule[commonmark/render/scribble]

@defproc[(document->scribble [doc document?]
                             [#:title title (or/c string? #f) #f]
                             [#:author author (or/c string? #f) #f]
                             [#:author-email author-email (or/c string? #f) #f])
         string?]{

 Convert a parsed Markdown document to a corresponding Scribble document.

 If a title isn't provided, the first level-1 heading (if any) in the document is used.

}

@defproc[(write-scribble [doc document?] [out output-port? (current-output-port)]
                             [#:title title (or/c string? #f) #f]
                             [#:author author (or/c string? #f) #f]
                             [#:author-email author-email (or/c string? #f) #f])
         void?]{

 Write out the Scribble document corresponding to the parsed Markdown document to the given port.

 If a title isn't provided, the first level-1 heading (if any) in the document is used.

}

@defparam[scribble-lang lang string? #:value "base"]{

 The Scribble language to use for the output. A @tt{scribble/} is automatically prepended, so the default @code{"base"} becomes @code{#lang scribble/base} and so on.

}

@section{Command-line utility}

The package also installs a command line program to convert files called @code{md2scrbl}. It reads markdown specified either by a filename given on the command line
or data read from standard input, and writes to standard output.

Run it with @code{--help} to see available options to specify fields like title and author.
