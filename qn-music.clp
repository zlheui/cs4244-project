; MUSIC module
(defmodule MUSIC
	(import MAIN ?ALL)
)

; Ask questions specific to the current purpose.
(defrule MUSIC::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 30)&:(>= ?qn-id 20))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

; Convert quenstion of weight requirement.
(defrule MUSIC::q20-convert 
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 20)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
)

; Convert quenstion of battery life requirement.
(defrule MUSIC::q21-convert
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 21)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "n") 0) then
		(modify ?req(battery-life-lower 5.0))
	)
	(focus MUSIC-MATCH)
)

(deffacts MUSIC::load-question-descriptions
	(qn-dscpt(id 20)(content "Do you often carry your laptop?<bool></end>"))
	(qn-dscpt(id 21)(content "Is there a readily available power source when using your laptop?<bool></end>"))
)

(deffacts MUSIC::test-qn-music
	(qn-ans(id 21))
	(qn-ans(id 20))
)

