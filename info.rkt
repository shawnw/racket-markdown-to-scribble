#lang info
(define collection 'multi)
(define deps '("base" "commonmark-lib" "soup-lib"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define pkg-desc "Convert CommonMark to Scribble")
(define version "0.9")
(define pkg-authors '(shawnw))
(define license '(Apache-2.0 OR MIT))
