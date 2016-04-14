; QUESTION-OFFICE module
(defmodule QUESTION-OFFICE
	(import MAIN deftemplate qn-dscpt qn-ans laptop-requirement)
)

(defrule QUESTION-OFFICE::ask-qn-office
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 20)&:(>= ?qn-id 10))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule QUESTION-OFFICE::initial-convert
	?init<-(init-office-req)
	?req<-(laptop-requirement)
	=>
	(modify ?req(memory-lower 2)(storage-size-lower 128))
	(retract ?init)
)

(defrule QUESTION-OFFICE::q10-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 10)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION-OFFICE::q11-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 11)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 6))
	)
	(modify ?qn(converted Y))
)

(deffacts QUESTION-OFFICE::load-QUESTION-OFFICE-descriptions
	(qn-dscpt(id 10)(content "Do you require light-weight laptop? (y/n)%nans: ")); weight
	(qn-dscpt(id 11)(content "Could you access the power source in usual usage environments? (y/n)%nans: ")); battery
)

(deffacts QUESTION-OFFICE::test-qn
	(qn-ans(id 11))
	(qn-ans(id 10))
	(init-office-req)
)

