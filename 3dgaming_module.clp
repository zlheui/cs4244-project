; 3DGAME module

(defmodule 3DGAME 
	(import MAIN ?ALL)
)

;(deftemplate 3DGAME::qn-dscpt
;	(slot id (type INTEGER))
;	(slot content (type STRING))
;)

;(deftemplate 3DGAME::qn-ans
;	(slot id (type INTEGER))
;	(slot ans (default NIL))
;	(slot converted (type SYMBOL)(default N))
;)

(defrule 3DGAME::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule 3DGAME::initial_convert
	?req <- (laptop-requirement (id test))
	?fact <-(initial-requirement)
	=>
	(retract ?fact)
	(modify ?req(memory-lower 8) (storage-size-lower 512) (has-discrete-graphic-card Y))
)

(defrule 3DGAME::q0-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
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

(defrule 3DGAME::q1-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(is-fhd Y))
	else (if (= ?a 2) then
		(modify ?req(is-ultra-hd Y))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
	(modify ?qn(converted Y))
	(focus 3DGAMEMATCH)
)

(deffacts 3DGAME::load-question-descriptions
	(qn-dscpt(id 0)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 1)(content "What screen resolution would you prefer?%n1. FHD    2. 4K    3. No requirement%nans:"))
)

(deffacts 3DGAME::test-qn-3DGAME
	(qn-ans(id 1))
	(qn-ans(id 0))
	(initial-requirement)
)
