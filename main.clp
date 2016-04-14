; MAIN class to coordinate laptop recommendation system
(defmodule MAIN
	;(export deftemplate laptop-requirement)
	(export ?ALL)
) 

; Initial setup

(deftemplate MAIN::output
	(slot id (type SYMBOL) (default REQ))
	(multislot model (type SYMBOL) (default none))
)

(deftemplate MAIN::laptop
	(slot brand (type SYMBOL))
	(slot model (type SYMBOL))
	(slot price (type FLOAT))
	(slot screen-size (type FLOAT))
	(slot screen-resolution-x (type INTEGER))
	(slot screen-resolution-y (type INTEGER))
	(slot is-fhd (type SYMBOL))
	(slot is-ultra-hd (type SYMBOL))
	(slot is-touchable (type SYMBOL))
	(slot weight (type FLOAT))
	(slot cpu (type STRING))
	(slot processor-brand (type STRING))
	(slot processor-model (type STRING))
	(slot processor-cores (type INTEGER))
	(slot processor-speed (type FLOAT))
	(slot memory (type INTEGER))
	(slot memory-type (type STRING))
	(slot gpu (type STRING))
	(slot has-discrete-graphic-card (type SYMBOL))
	(slot storage-size (type INTEGER))
	(slot storage-type (type SYMBOL))
	(slot storage-speed (type INTEGER))
	(slot configurable (type STRING))
	(slot battery-life (type INTEGER))
	(slot os (type STRING))
	(slot warranty (type INTEGER))
	(slot colors (type STRING))
	(slot detachable (type SYMBOL)))

(deftemplate MAIN::laptop-requirement
	(slot id (type SYMBOL) (default REQ))
	(multislot brand (type SYMBOL) (default none))
	(multislot model (type SYMBOL) (default none))
	(slot price-upper (type FLOAT) (default 1000000.0))
	(slot screen-size-lower (type FLOAT) (default -1.0))
	(slot screen-size-upper (type FLOAT) (default 100.0))
	(slot screen-resolution-x-lower (type INTEGER) (default -1))
	(slot screen-resolution-y-lower (type INTEGER) (default -1))
	(slot is-fhd (type SYMBOL) (default none))
	(slot is-ultra-hd (type SYMBOL) (default none))
	(slot is-touchable (type SYMBOL) (default none))
	(slot weight-lower (type FLOAT) (default -1.0))
	(slot weight-upper (type FLOAT) (default -1.0))
	(multislot cpu (type STRING) (default "none"))
	(multislot processor-brand (type STRING) (default "none"))
	(multislot processor-model (type STRING) (default "none"))
	(multislot processor-cores (type INTEGER) (default -1))
	(slot processor-speed-lower (type FLOAT) (default -1.0))
	(slot processor-speed-upper (type FLOAT) (default -1.0))
	(slot memory-lower (type INTEGER) (default -1))
	(slot memory-upper (type INTEGER) (default -1))
	(multislot memory-type (type STRING) (default "none"))
	(multislot gpu (type STRING) (default "none"))
	(slot has-discrete-graphic-card (type SYMBOL) (default none))
	(slot storage-size-lower (type INTEGER) (default -1))
	(slot storage-size-upper (type INTEGER) (default -1))
	(multislot storage-type (type SYMBOL) (default none))
	(slot storage-speed-lower (type INTEGER) (default -1))
	(slot storage-speed-upper (type INTEGER) (default -1))
	(slot configurable (type STRING) (default "none"))
	(slot battery-life-lower (type INTEGER) (default -1))
	(multislot os (type STRING) (default "none"))
	(slot warranty-lower (type INTEGER) (default -1))
	(multislot colors (type STRING) (default "none"))
	(slot detachable (type SYMBOL) (default none))
	(slot is-ansd (type SYMBOL)(default N))
)

; Template for questions
(deftemplate MAIN::qn-dscpt
	(slot id (type INTEGER))
	(slot content (type STRING))
)

(deftemplate MAIN::qn-ans
	(slot id (type INTEGER))
	(slot ans (default NIL))
	(slot converted (type SYMBOL)(default N))
)

(defrule MAIN::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 10))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule MAIN::q0-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
;	(if (= ?a 1) then (focus OFFICE) (assert (initial-office-requirement))
;		else (if (= ?a 2) then (focus MUSIC) (assert (initial-music-requirement))
;		else (if (= ?a 3) then (focus CASUALGAME) (assert (initial-casualgame-requirement))
;		else (if (= ?a 4) then (focus PROGRAMMING) (assert (initial-programming-requirement))
;		else (if (= ?a 5) then (focus 3DGAME) (assert (initial-3dgame-requirement))
;	)))))
	(if (= ?a 1) then (assert (initial-office-requirement))
		else (if (= ?a 2) then (assert (initial-music-requirement))
		else (if (= ?a 3) then (assert (initial-casualgame-requirement))
		else (if (= ?a 4) then (assert (initial-programming-requirement))
		else (if (= ?a 5) then (assert (initial-3dgame-requirement))
	)))))
)

(defrule MAIN::change-focus
	?premise <- (can-change-focus)
	?qn <- (qn-ans(id 0)(ans ?a)(converted Y))
	=>
	(retract ?premise)
	(if (= ?a 1) then (focus OFFICE) ;(assert (initial-office-requirement))
		else (if (= ?a 2) then (focus MUSIC) ;(assert (initial-music-requirement))
		else (if (= ?a 3) then (focus CASUALGAME) ;(assert (initial-casualgame-requirement))
		else (if (= ?a 4) then (focus PROGRAMMING) ;(assert (initial-programming-requirement))
		else (if (= ?a 5) then (focus 3DGAME) ;(assert (initial-3dgame-requirement))
	)))))
)

(defrule MAIN::q1-convert ; Price
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(modify ?req(price-upper ?a))
)

(defrule MAIN::q2-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 2)(ans ?a)(converted N))
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

(defrule MAIN::q3-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 3)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(is-fhd Y))
	else (if (= ?a 2) then
		(modify ?req(is-ultra-hd Y))
	))
	(assert (can-change-focus))
)

(deffacts MAIN::load-question-descriptions
	(qn-dscpt(id 0)(content "Why do you want a new computer? 
			1. Office work 
			2. Entertainment 
			3. Web Browsing 
			4. Development 
			5. Gaming%nMy purpose is: "))
	(qn-dscpt(id 1)(content "How much do you want to pay for your new computer?%nPrice:"))
	(qn-dscpt(id 2)(content "How big do you want your computer to be (in inch)?
		1. 11~13.3    2. 13.3~15    3. larger than 15    4. don't care%nI want:"))
	(qn-dscpt(id 3)(content "What screen resolution do you prefer?
		1. FHD    2. 4K    3. don't care%nI prefer:"))
)

(deffacts MAIN::test-qn
	(qn-ans(id 3))
	(qn-ans(id 2))
	(qn-ans(id 1))
	(qn-ans(id 0))
)

; Initialize laptop requirement to empty requirement
(deffacts MAIN::init-req
	(laptop-requirement (id test))
	(output (id test))
)

;(defrule MAIN::ask-question
;	?requirement <- (laptop-requirement(is-ansd N))
;	=>
;	(focus 3DGAME)
;	(modify ?requirement (is-ansd Y))
;)


