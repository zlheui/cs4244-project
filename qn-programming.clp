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

(defrule PROGRAMMING::q40-convert ; IOS
	?req <- (laptop-requirement(os ?old-os))
	?qn <- (qn-ans(id 40)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(os "OS X"))
	)
)

(defrule PROGRAMMING::q41-convert ; Weight
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 41)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 1.6))
	)
)

(defrule PROGRAMMING::q42-convert ; Battery
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 42)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 6.0))
	)
	(focus PROGRAMMING-MATCH)
)

(deffacts PROGRAMMING::load-question-descriptions
	(qn-dscpt(id 40)(content "Do you need to do IOS development? (y/n)%n"))
	(qn-dscpt(id 41)(content "Do you often carry your laptop? (y/n)%n"))
	(qn-dscpt(id 42)(content "Is there a readily available power source when using your laptop? (y/n)%n"))
)

(deffacts PROGRAMMING::test-qn-programming
	(qn-ans(id 42))
	(qn-ans(id 41))
	(qn-ans(id 40))
)

