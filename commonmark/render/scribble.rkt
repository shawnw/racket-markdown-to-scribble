#lang racket/base

;; convert a commonmark document to scribble

(require racket/contract racket/match racket/port
         commonmark commonmark/struct soup-lib/parameter)
(provide
 (contract-out
  [scribble-lang (parameter/c string?)]
  [document->scribble (->* (document?)
                           (#:title (or/c string? #f) #:author (or/c string? #f) #:author-email (or/c string? #f)) string?)]
  [write-scribble (->* (document?)
                       (output-port? #:title string? #:author (or/c string? #f) #:author-email (or/c string? #f)) void?)]))

(define (document->scribble doc #:title [title #f] #:author [author #f] #:author-email [author-email #f])
  (call-with-output-string
   (lambda (out)
     (write-scribble doc out #:title title #:author author #:author-email author-email))))

(define (write-scribble doc [out (current-output-port)] #:title [title #f] #:author [author #f] #:author-email [author-email #f])
  (write-scribble-header doc title author author-email out)
  (write-blocks (document-blocks doc) out))

(define-parameter scribble-lang "base")

(define (write-scribble-header doc title author author-email out)
  (case (scribble-lang)
    (("base" "manual" "book" "report" "sigplan" "acmart" "jfp" "lncs") ; standard scribble/XXX languages
     (fprintf out "#lang scribble/~A~%~%" (scribble-lang)))
    (else
     (fprintf out "#lang ~A~%~%" (scribble-lang))))
  (cond
    (title
     (fprintf out "@title[~S]~%" title))
    ((findf (match-lambda
              [(struct heading (_ 1)) #t]
              [_ #f])
            (document-blocks doc))
     =>
     (lambda (header1)
       (write-string "@title{" out)
       (write-inline (heading-content header1) out)
       (write-string "}\n" out))))
  (cond
    ((and author author-email)
     (fprintf out "@author[(author+email ~S ~S)]~%" author author-email))
    (author
     (fprintf out "@author[~S]~%" author))))

(define (write-blocks blocks out)
  (for ([block (in-list blocks)])
    (write-block block out)))

(define-boolean-parameter wrap-paragraphs #f)

(define (write-block block out)
  (match block
    [(struct paragraph (content))
     (cond
       ((wrap-paragraphs)
        (write-string "@para{" out)
        (write-inline content out)
        (write-string "}\n" out))
       (else
        (write-inline content out)
        (write-string "\n\n" out)))]
    [(struct itemization (blocks style start-num))
     (if start-num
         (write-list blocks style 'ordered out)
         (write-list blocks style #f out))]
    [(struct blockquote (blocks))
     (write-string "@nested[#:style 'inset]{\n" out)
     (write-blocks blocks out)
     (write-string "}\n" out)]
    [(struct code-block (content info))
     (fprintf out "@nested[#:style 'code-inset]{@verbatim[~S]}~%" content)]
    [(struct html-block (content))
     (error "html-block not supported")]
    [(struct heading (title depth))
     (case depth
       ((1)
        (write-string "@section{" out)
        (write-inline title out)
        (write-string "}\n" out))
       ((2)
        (write-string "@subsection{" out)
        (write-inline title out)
        (write-string "}\n" out))
       ((3)
        (write-string "@subsubsection{" out)
        (write-inline title out)
        (write-string "}\n" out))
       (else
        (write-string "@subsubsub*section{" out)
        (write-inline title out)
        (write-string "}\n")))]
    [(? thematic-break? _)
     (void)] ; Need to figure out what to use for this
    [_
     (error "Unknown block element" block)]))

(define (escape-at-exp str)
  (regexp-replace*
   #px"[@{}\\[\\]]"
   str
   (lambda (escape) (string-append "@\"" escape "\""))))

(define (write-inline content out)
  (match content
    [(? string? text)
     #;(fprintf out "@~S" text)
     (write-string (escape-at-exp text) out)]
    [(? list? elems)
     (for ([elem (in-list elems)])
       (write-inline elem out))]
    [(struct italic (content))
     (write-string "@italic{" out)
     (write-inline content out)
     (write-char #\} out)]
    [(struct bold (content))
     (write-string "@bold{" out)
     (write-inline content out)
     (write-char #\} out)]
    [(struct code (text))
     (fprintf out "@tt[~S]" text)]
    [(struct link (content url title))
     (fprintf out "@hyperlink[~S]{" url)
     (write-inline content out)
     (write-char #\} out)]
    [(struct image (desc url title))
     (fprintf out "@image[~S]{" url)
     (write-inline desc out)
     (write-char #\} out)]
    [(struct footnote-reference (label))
     (error "footnotes not yet supported")]
    [(struct html (text))
     (error "inline html not supported")]
    [(? line-break? _)
     (write-string "@linebreak\n" out)]
    (_
     (error "Unknown inline element" content))))

(define (write-list blocks para-style list-style out)
  (fprintf out "@itemlist[#:style ~V~%" list-style)
  (parameterize [(wrap-paragraphs (eq? para-style 'tight))]
    (for ([blocklist (in-list blocks)])
      (write-string "@item{" out)
      (write-blocks blocklist out)
      (write-string "}\n" out)))
  (write-string "]\n" out))

(module+ main
  (require racket/cmdline)

  (define (convert-markdown in out title author author-email)
    (write-scribble (read-document in) out
                    #:title title
                    #:author author
                    #:author-email author-email))

  (define-parameter title #f)
  (define-parameter author #f)
  (define-parameter email #f)

  (define input-filenames
    (command-line #:program "md2scrbl"
                  #:once-each
                  [("-t" "--title") t "Title of the document" (title t)]
                  [("-a" "--author") a "Author of document" (author a)]
                  [("-e" "--email") e "Email address of author" (email e)]
                  [("-l" "--lang") lang "Scribble sub-language to use (Default is base)" (scribble-lang lang)]
                  #:args filenames
                  filenames))

  (match input-filenames
    ('()
     (convert-markdown (current-input-port) (current-output-port) (title) (author) (email)))
    ((list input-filename)
     (call-with-input-file input-filename
       (lambda (in)
         (convert-markdown in (current-output-port) (title) (author) (email)))))
    (_ (write-string "md2scrbl expects 0 or 1 input files\n" (current-error-port))
       (exit 1))))
