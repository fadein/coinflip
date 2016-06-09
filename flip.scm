#!/usr/local/bin/csi -s
; http://ascii-table.com/ansi-escape-sequences-vt-100.php

(use ansi-escape-sequences srfi-1 srfi-13 srfi-18 posix)
(include "dude.scm")

(define (make-spinner chars)
  (let ((chars (cond
                 ((string? chars)
                  (apply circular-list (string->list chars)))
                 ((list? chars)
                  (apply circular-list chars)))))
    (lambda ()
		(set! chars (cdr chars))
		(car chars))))

(define back-flip (make-spinner "-/|\\"))

(set-buffering-mode! (current-output-port) #:none)

(define up 9)
(define height 11)
(define right 15)
(define delay 0.1)

(display (hide-cursor))

(print dude)

; position cursor right after the coin
(print* (cursor-up up) (cursor-forward right))

; coin go up
(thread-sleep! delay)

(print* (cursor-backward 1) #\i (cursor-backward 1) (cursor-up 1) #\|)
(thread-sleep! delay)

(do ((i 1 (add1 i))) ((= i height))
	(print* (cursor-backward 1) #\space
			(cursor-backward 1)
			(cursor-up 1) (back-flip))
	(thread-sleep! delay))

; coin go down
(do ((i 1 (add1 i))) ((> i height))
	(print* (cursor-backward 1) #\space
			(cursor-backward 1)
			(cursor-down 1) (back-flip))
	(thread-sleep! delay))

(print* 
  (cursor-backward 1) #\space
  (cursor-down 1)
  (cursor-backward 1) 
  (cursor-up 1) #\-)


; put the cursor back beneath the guy
(print* (cursor-backward right) (cursor-down up))

; print the result of the flip
(printf "\nIt's ~s\n" (if (= 0 (random 2)) "heads" "tails"))

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
