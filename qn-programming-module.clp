; PROGRAMMING module
(defmodule PROGRAMMING
	(import MAIN ?ALL)
)

(defrule PROGRAMMING::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 50)&:(>= ?qn-id 40))(content ?qn-cnt))
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

(defrule PROGRAMMING::q40-convert ; Price
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 40)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))å
	(modify ?req(price-upper ?a))
)

(defrule PROGRAMMING::q41-convert ; Screen size
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 41)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(screen-size-lower 11.0) (screen-size-upper 13.3))
	else (if (= ?a 2) then
		(modify ?req(screen-size-lower 13.3) (screen-size-upper 15.0))
	else (if (= ?a 3) then
		(modify ?req(screen-size-lower 15.0))
	)))
)

(defrule PROGRAMMING::q42-convert ; IOS
	?req <- (laptop-requirement(os ?old-os))
	?qn <- (qn-ans(id 42)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(os "IOS"))
	)
)

(defrule PROGRAMMING::q43-convert ; Weight
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 43)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
)

(defrule PROGRAMMING::q44-convert ; Battery
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 44)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 5))
	)
)

(deffacts PROGRAMMING::load-question-descriptions
	(qn-dscpt(id 40)(content "How much money do you want to spend on the new computer?%n"))
	(qn-dscpt(id 41)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 42)(content "Do you need to do IOS development? (y/n)%n"))
	(qn-dscpt(id 43)(content "Do you often carry your laptop? (y/n)%n"))
	(qn-dscpt(id 44)(content "Is there a readily available power source when using your laptop? (y/n)%n"))
)

(deffacts PROGRAMMING::test-qn-programming
	(qn-ans(id 44))
	(qn-ans(id 43))
	(qn-ans(id 42))
	(qn-ans(id 41))
	(qn-ans(id 40))
)

