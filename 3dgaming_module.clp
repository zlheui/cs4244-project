; 3DGAME module
(defmodule 3DGAME
	(import MAIN deftemplate qn-dscpt qn-ans laptop-requirement)
)

(defrule 3DGAME::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 60)&:(>= ?qn-id 50))(content ?qn-cnt))
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

(defrule 3DGAME::q50-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 50)(ans ?a)(converted N))
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

(defrule 3DGAME::q51-convert
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 51)(ans ?a)(converted N))
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
	(qn-dscpt(id 50)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 51)(content "What screen resolution would you prefer?%n1. FHD    2. 4K    3. No requirement%nans:"))
)

(deffacts 3DGAME::test-qn-3DGAME
	(qn-ans(id 51))
	(qn-ans(id 50))
)
