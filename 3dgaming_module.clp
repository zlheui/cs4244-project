; QUESTION module
(defmodule 3dgaming 
	(import MAIN ?ALL)
)

(deftemplate 3dgaming::qn-dscpt
	(slot id (type INTEGER))
	(slot content (type STRING))
)

(deftemplate 3dgaming::qn-ans
	(slot id (type INTEGER))
	(slot ans (default NIL))
	(slot converted (type SYMBOL)(default N))
)

(defrule 3dgaming::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule 3dgaming::initial_convert
	?req <- (laptop-requirement)
	(initial-requirement)
	=>

	(modify ?req(memory-lower 8))
	(modify ?req(storage-size-lower 512))
	(modify ?req(has-discrete-graphic-card Y))
)

(defrule 3dgaming::q0-convert
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(cpu $?old-cpu "i3"))
	)
	(modify ?qn(converted Y))
)

(defrule 3dgaming::q1-convert
	?req <- (laptop-requirement(price-upper ?old-upper))
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?req(price-upper ?a))
	(modify ?qn(converted Y))
)

(deffacts 3dgaming::load-question-descriptions
	(qn-dscpt(id 0)(content "What screen size would you prefer?%n"))
	(qn-dscpt(id 1)(content "What screen resolution would you prefer?%n"))
)

(deffacts 3dgaming::test-qn
	(qn-ans(id 1))
	(qn-ans(id 0))
	(initial-requirement)
)

