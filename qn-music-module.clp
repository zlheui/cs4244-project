; MUSIC module
(defmodule MUSIC
	(import MAIN ?ALL)
)

(defrule MUSIC::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 30)&:(>= ?qn-id 20))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule MUSIC::initial-convert
	?req <- (laptop-requirement)
	?fact <- (initial-music-requirement)
	=>
	(retract ?fact)
	(modify ?req
		(memory-lower 2)
		(storage-size-lower 512)
		(has-discrete-graphic-card N)
	)
)

(defrule MUSIC::q20-convert ; Price
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 20)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(modify ?req(price-upper ?a))
)

(defrule MUSIC::q21-convert ; Screen size
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 21)(ans ?a)(converted N))
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

(defrule MUSIC::q22-convert ; Screen resolution
	?req <- (laptop-requirement (id test))
	?qn <- (qn-ans(id 22)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(is-fhd Y))
	else (if (= ?a 2) then
		(modify ?req(is-ultra-hd Y))
	))
)

(defrule MUSIC::q23-convert ; Weight
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 23)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 2.0))
	)
)

(defrule MUSIC::q24-convert ; Battery
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 24)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 5))
	)
)

(deffacts MUSIC::load-question-descriptions
	(qn-dscpt(id 20)(content "How much money do you want to spend on the new computer?%n"))
	(qn-dscpt(id 21)(content "What screen size would you prefer?%n1. 11~13.3    2. 13.3~15    3. 15~    4. No requirement%nans:"))
	(qn-dscpt(id 22)(content "What screen resolution would you prefer?%n1. FHD    2. 4K    3. No requirement%nans:"))
	(qn-dscpt(id 23)(content "Do you often carry your laptop? (y/n)%n"))
	(qn-dscpt(id 24)(content "Is there a readily available power source when using your laptop? (y/n)%n"))
)

(deffacts MUSIC::test-qn-music
	(qn-ans(id 24))
	(qn-ans(id 23))
	(qn-ans(id 22))
	(qn-ans(id 21))
	(qn-ans(id 20))
)

