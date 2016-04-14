; QUESTION-OFFICE module
(defmodule QUESTION-OFFICE
	(import MAIN qn-dscpt qn-ans)
)

(defrule QUESTION-OFFICE::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule QUESTION-OFFICE::initial-convert
	?req <- (laptop-requirement)
	?init <- (initial-requirement)
	=>
	(retract ?init)
	(modify ?req(memory-lower 2)(storage-size-lower 128)
)

(defrule QUESTION-OFFICE::q0100-convert
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(cpu $?old-cpu "i3"))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION-OFFICE::q0101-convert
	?req <- (laptop-requirement(is-hd ?old-hd)(is-ultra-hd ?old-ultra-hd))
	?qn <- (qn-ans(id 2)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(is-hd Y))
	else (if (= ?a 2) then
		(modify ?req(is-ultra-hd Y))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
	(modify ?qn(converted Y))
)

(defrule QUESTION-OFFICE::q0102-convert
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 3)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION-OFFICE::q0103-convert
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 0103)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 6))
	)
	(modify ?qn(converted Y))
)

(deffacts QUESTION-OFFICE::load-QUESTION-OFFICE-descriptions
	(qn-dscpt(id 0100)(content "What screen size do you prefer?%n 1. 11'    2. 13'    3. No special requirement%nans: ")); screen size
	(qn-dscpt(id 0101)(content "Do you require FHD or 4K display?%n(Note that higher screen resolution can achieve better photo editing experience)%n 1. FHD    2. 4K    3. No requirement%nans: "));screen resolution
	(qn-dscpt(id 0102)(content "Do you require light-weight laptop? (y/n)%nans: ")); weight
	(qn-dscpt(id 0103)(content "Could you access the power source in usual usage environments? (y/n)%nans: ")); battery
)

(deffacts QUESTION-OFFICE::test-qn
	(qn-ans(id 0103))
	(qn-ans(id 0102))
	(qn-ans(id 0101))
	(qn-ans(id 0100))
	(initial-requirement)
)

