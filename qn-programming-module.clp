; PROGRAMMING module
(defmodule PROGRAMMING
	(import MAIN ?ALL)
)

(defrule PROGRAMMING::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule PROGRAMMING::initial-convert
	?req <- (laptop-requirement (id test))
	?fact <- (initial-requirement)
	=>
	(retract ?fact)
	(modify ?req
		(memory-lower 4)
		(storage-size-lower 256)
		(has-discrete-graphic-card N)
	)
)

(defrule PROGRAMMING::q0-convert ; Price
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?req(price-upper ?a))
	(modify ?qn(converted Y))
)

(defrule PROGRAMMING::q1-convert ; Screen size
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
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

(defrule PROGRAMMING::q2-convert ; IOS
	?req <- (laptop-requirement(os ?old-os))
	?qn <- (qn-ans(id 2)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(os "IOS"))
	)
	(modify ?qn(converted Y))
)

(defrule PROGRAMMING::q3-convert ; Weight
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 3)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
	(modify ?qn(converted Y))
)

(defrule PROGRAMMING::q4-convert ; Battery
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 4)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 5))
	)
	(modify ?qn(converted Y))
)

(deffacts PROGRAMMING::load-question-descriptions
	(qn-dscpt(id 0)(content "How much money do you want to spend on the new computer?%n"))
	(qn-dscpt(id 1)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 2)(content "Do you need to do IOS development? (y/n)%n"))
	(qn-dscpt(id 3)(content "Do you often carry your laptop? (y/n)%n"))
	(qn-dscpt(id 4)(content "Is there a readily available power source when using your laptop? (y/n)%n"))
)

(deffacts PROGRAMMING::test-qn-music
	(qn-ans(id 4))
	(qn-ans(id 3))
	(qn-ans(id 2))
	(qn-ans(id 1))
	(qn-ans(id 0))
	(initial-requirement)
)

