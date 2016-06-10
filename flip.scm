#!/usr/local/bin/csi -s
; http://ascii-table.com/ansi-escape-sequences-vt-100.php

(use ansi-escape-sequences srfi-1 srfi-13 srfi-18 posix)

(define (make-spinner chars)
  (let ((chars (cond
                 ((string? chars)
                  (apply circular-list (string->list chars)))
                 ((list? chars)
                  (apply circular-list chars)))))
    (lambda ()
		(set! chars (cdr chars))
		(conc "[1;33m" (car chars) "[0m"))))
(define back-flip (make-spinner "-/|\\"))

(include "dude.scm")
(define up 9)
(define height 11)
(define right 15)
(define pause 0.07)

(set-buffering-mode! (current-output-port) #:none)
(display (hide-cursor))
(print dude)

; color the coin yellow
(print* (cursor-up up) (cursor-forward (sub1 right)) "[1;33m-" )
(thread-sleep! (* pause 4))

; coin go up
(print* (cursor-backward 1) "[0;33mi" (cursor-backward 1) (cursor-up 1) "[1;33m|")
(thread-sleep! pause)

(do ((i 1 (add1 i))) ((= i height))
	(print* (cursor-backward 1) #\space
			(cursor-backward 1)
			(cursor-up 1) (back-flip))
	(thread-sleep! pause))

; spin for a moment
(do ((i 1 (add1 i))) ((= i 4))
	(print* (cursor-backward 1) (back-flip))
	(thread-sleep! pause))

; coin go down
(do ((i 1 (add1 i))) ((> i height))
	(print* (cursor-backward 1) #\space
			(cursor-backward 1)
			(cursor-down 1) (back-flip))
	(thread-sleep! pause))

(print* (cursor-backward 1) #\space (cursor-down 1) (cursor-backward 1) (cursor-up 1) "[1;33m-[0m")

(thread-sleep! (* pause 2))

; put the cursor back beneath the guy
(print* (cursor-backward right) (cursor-down up))

; print the result of the flip
(printf "\nIt's ~s\n" (if (= 0 (random 2)) 'heads 'tails))

(when (not (zero? (length (command-line-arguments))))
  (let ((alternatives (filter (lambda (s) (string-ci<> s "or")) (command-line-arguments))))
	(printf "You should go with ~s\n"
	(list-ref alternatives (random (length alternatives))))))

;restore cursor
(display (show-cursor))

;; __DATA__
;; \e[nA up n lines
;; \e[nB down n lines
;; \e[nC right n cols
;; \e[nD left n cols
