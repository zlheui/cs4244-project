; OFFICE module
(defmodule OFFICE
	(import MAIN ?ALL)
)

(defrule OFFICE::ask-qn-office
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 20)&:(>= ?qn-id 10))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule OFFICE::initial-convert
	?init <- (initial-office-requirement)
	?req <- (laptop-requirement)
	=>
	(retract ?init)
	(modify ?req(memory-lower 2)(storage-size-lower 128))
)

(defrule OFFICE::q10-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 10)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
)

(defrule OFFICE::q11-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 11)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 6))
	)
)

(deffacts OFFICE::load-QUESTION-OFFICE-descriptions
	(qn-dscpt(id 10)(content "Do you require light-weight laptop? (y/n)%nans: ")); weight
	(qn-dscpt(id 11)(content "Could you access the power source in usual usage environments? (y/n)%nans: ")); battery
)

(deffacts OFFICE::test-qn
	(qn-ans(id 11))
	(qn-ans(id 10))
)

