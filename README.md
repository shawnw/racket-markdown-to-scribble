markdown-to-scribble
====================

Convert markdown text to Scribble markup.

Some samples for testing:

* a
* bullet
* list with code `(+ 1 2)` and *markup*

and

1. a
2. numbered
3. list with code `@linebreak` and **markup**

a subsection
------------

    a code block
    (+ 1 2)

### and deeper subsubsection

some text with [a link](https://racket-lang.org) in it.

> a block
> quote
> of text

Some text with @bold{scribble} markup that shouldn't be parsed.

and a second paragraph immediately following.

#### A level-4 heading


```scheme
; a fenced code block of scheme
(+ 1 2 3)
```

and one of racket

```racket
(require racket/vector)
(define (do-some-stuff)
  #t)
```

these test different renderings for the scribble/manual lang.

