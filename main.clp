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
	(slot detachable (type SYMBOL))
)

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
	(if (= ?a 2) then (focus MUSIC)
	else (if (= ?a 4) then (focus PROGRAMMING)
		else (if (= ?a 5) then (focus 3DGAME))))
	(modify ?qn(converted Y))
)

(deffacts MAIN::load-question-descriptions
	(qn-dscpt(id 0)(
		content "What is the new computer mainly used for?%n 
			1. Office work%n 
			2. Music and movies%n 
			3. Programming%n 
			4. Photo, video processing%n 
			5. Gaming%nans: "))
)

(deffacts MAIN::test-qn
	(qn-ans(id 0))
)

; Initialize laptop requirement to empty requirement
(deffacts MAIN::init-req
	(laptop-requirement (id test))
	(output (id test))
)

(defrule MAIN::ask-question
	?requirement <- (laptop-requirement(is-ansd N))
	=>
	(focus CASUALGAME)
	(modify ?requirement (is-ansd Y))
)


