; QUESTION module
(defmodule QUESTION 
	(import MAIN ?ALL)
)


(deftemplate QUESTION::qn-dscpt
	(slot id (type INTEGER))
	(slot content (type STRING))
)

(deftemplate QUESTION::qn-ans
	(slot id (type INTEGER))
	(slot ans (default NIL))
	(slot converted (type SYMBOL)(default N))
)

(defrule QUESTION::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id)(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule QUESTION::q0-convert
	?req <- (laptop-requirement(cpu $?old-cpu))
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(cpu $?old-cpu "i3"))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION::q1-convert
	?req <- (laptop-requirement(price-upper ?old-upper))
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?req(price-upper ?a))
	(modify ?qn(converted Y))
)

(defrule QUESTION::q2-convert
	?req <- (laptop-requirement(is-hd ?old-hd)(is-ultra-hd ?old-ultra-hd))
	?qn <- (qn-ans(id 2)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= ?a 1) then
		(modify ?req(is-ultra-hd Y))
	else (if (= ?a 2) then
		(modify ?req(is-hd Y))
	else (if (<> ?a 3) then
		(printout t "Invalid input.")
	)))
	(modify ?qn(converted Y))
)

(defrule QUESTION::q3-convert
	?req <- (laptop-requirement(weight-upper ?old-weight-upper))
	?qn <- (qn-ans(id 3)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(weight-upper 2.0))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION::q4-convert
	?req <- (laptop-requirement(storage-size-lower ?old-storage-lower))
	?qn <- (qn-ans(id 4)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(storage-size-lower 500))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION::q5-convert
	?req <- (laptop-requirement(battery-life-lower ?old-battery-lower))
	?qn <- (qn-ans(id 5)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(battery-life-lower 5))
	)
	(modify ?qn(converted Y))
)

(defrule QUESTION::q6-convert
	?req <- (laptop-requirement(os $?old-os))
	?qn <- (qn-ans(id 6)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(if (= (str-compare ?a "y") 0) then
		(modify ?req(os $?old-os "Mac"))
	)
	(modify ?qn(converted Y))
)

(deffacts QUESTION::load-question-descriptions
	(qn-dscpt(id 0)(content "What is the new computer mainly used for?%n 1. Office work%n 2. Music and movies%n 3. Programming%n 4. Photo, video processing%n 5. Gaming%nans: "))
	(qn-dscpt(id 1)(content "How much money do you want to spend on the new computer?%n"))
	(qn-dscpt(id 2)(content "Do you require HD or 4K display?%n(Note that higher screen resolution can achieve better web browsing,%npicture viewing or movie watching experience)%n 1. 4K    2. HD    3. No requirement%nans: "))
	(qn-dscpt(id 3)(content "Do you often carry your laptop? (y/n)%n")) ; weight
	(qn-dscpt(id 4)(content "Would you use it to store photos, music or movies? (y/n)%n")) ; storage
	(qn-dscpt(id 5)(content "Could you access the power source in usual usage environments? (y/n)%n")) ; battery
	(qn-dscpt(id 6)(content "Do you require Mac OS? (eg. for developing iOS app) (y/n)%n")) ; OS
	(qn-dscpt(id 7)(content "Special requirements?"))
)

(deffacts QUESTION::test-qn
	(qn-ans(id 6))
	(qn-ans(id 5))
	(qn-ans(id 4))
	(qn-ans(id 3))
	(qn-ans(id 2))
	(qn-ans(id 1))
	(qn-ans(id 0))
)

