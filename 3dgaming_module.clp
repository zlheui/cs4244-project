; 3dgaming module

(defmodule 3dgaming 
	(import MAIN ?ALL)
)

;(deftemplate 3dgaming::qn-dscpt
;	(slot id (type INTEGER))
;	(slot content (type STRING))
;)

;(deftemplate 3dgaming::qn-ans
;	(slot id (type INTEGER))
;	(slot ans (default NIL))
;	(slot converted (type SYMBOL)(default N))
;)

(defrule 3dgaming::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule 3dgaming::initial_convert
	?req <- (laptop-requirement (id test))
	?fact <-(initial-requirement)
	=>
	(printout t "testinitial")
	(retract ?fact)
	(modify ?req(memory-lower 8) (storage-size-lower 512) (has-discrete-graphic-card Y))
)

(defrule 3dgaming::q0-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(printout t "test0")
		(modify ?req(screen-size-lower 11.0) (screen-size-upper 13.3))
	else (if (= ?a 2) then
		(modify ?req(screen-size-lower 13.3) (screen-size-upper 15.0))
	else (if (= ?a 3) then
		(modify ?req(screen-size-lower 15.0))
	else (if (<> ?a 4) then
		(printout t "Invalid input.")
	))))
	(modify ?qn(converted Y))
)

(defrule 3dgaming::q1-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(printout t "test 1")
	(if (= ?a 1) then
		(modify ?req(is-hd Y))
	else (if (= ?a 2) then
		(modify ?req(is-ultra-hd Y))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
	(modify ?qn(converted Y))
)

(deffacts 3dgaming::load-question-descriptions
	(qn-dscpt(id 0)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 1)(content "What screen resolution would you prefer?%n1. FHD    2. 4K    3. No requirement%nans:"))
)

(deffacts 3dgaming::test-qn-3dgaming
	(qn-ans(id 1))
	(qn-ans(id 0))
	(initial-requirement)
)



