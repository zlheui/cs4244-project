; CASUALGAME module

(defmodule CASUALGAME 
	(import MAIN ?ALL)
)

; Ask questions specific to the current purpose.
(defrule CASUALGAME::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 40)&:(>= ?qn-id 30))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

; Convert quenstion of touchable requirement.
(defrule CASUALGAME::q30-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 30)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(is-touchable Y))
	else (if (= ?a 2) then
		(modify ?req(is-touchable N))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
)

; Convert quenstion of detachable requirement.
(defrule CASUALGAME::q31-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 31)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(detachable Y))
	else (if (= ?a 2) then
		(modify ?req(detachable N))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
	(focus CASUALGAMEMATCH)
)

(deffacts CASUALGAME::load-question-descriptions
	(qn-dscpt(id 30)(content "Would you prefer the laptop to be touchable?<opt>1[Yes]    2[No]   3[No requirements]</end>"))
	(qn-dscpt(id 31)(content "Would you prefer the laptop to be detachable?<opt>1[Yes]    2[No]    3[No requirements]</end>"))
)

(deffacts CASUALGAME::test-qn-CASUALGAME
	(qn-ans(id 31))
	(qn-ans(id 30))
)
