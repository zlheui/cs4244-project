;;;======================================================
;;;   Laptop Recommendation System
;;;
;;;     A simple expert system which attempts to give
;;;     professional recommendations of laptops based
;;;     on user requirements.
;;;     The knowledge in this system is collected from
;;;     online sources.
;;; 
;;;     This system is implemented in CLIPS Version 6.3.
;;;     Follow README.md instructions to execute the
;;;     programming with a simple GUI.
;;;======================================================

; MAIN class to coordinate laptop recommendation system
(defmodule MAIN
	(export ?ALL)
) 

; DATASET module for laptop features
(defmodule DATASET
	(import MAIN ?ALL)
	(export ?ALL)
)

;;;**********************************
;;;* DEFGLOBAL TEMPLATES DEFINITION *
;;;**********************************

; Template for recommendations output.
(deftemplate MAIN::output
	(slot id (type SYMBOL) (default REQ))
	(multislot model (type STRING) (default "none"))
	(slot is-finished (type SYMBOL) (default N))
	(slot for-print (type STRING) (default "none"))
)

; Template for laptop data in DATASET.
(deftemplate MAIN::laptop
	(slot brand (type SYMBOL))
	(slot model (type STRING))
	(slot price (type FLOAT))
	(slot screen-size (type FLOAT))
	(slot screen-resolution-x (type INTEGER))
	(slot screen-resolution-y (type INTEGER))
	(slot is-fhd (type SYMBOL))
	(slot is-ultra-hd (type SYMBOL))
	(slot is-touchable (type SYMBOL))
	(slot weight (type FLOAT))
	(slot cpu (type STRING))
	(slot cpu-brand (type SYMBOL))
	(slot cpu-cores (type INTEGER))
	(slot cpu-class (type INTEGER))
	(slot cpu-model (type STRING))
	(slot cpu-frequency (type FLOAT))
	(slot processor-brand (type STRING))
	(slot processor-model (type STRING))
	(slot processor-cores (type INTEGER))
	(slot processor-speed (type FLOAT))
	(slot memory (type INTEGER))
	(slot memory-speed (type INTEGER))
	(slot memory-type (type STRING))
	(slot gpu (type STRING))
	(slot gpu-class (type INTEGER))
	(slot has-discrete-graphic-card (type SYMBOL))
	(slot storage-size (type INTEGER))
	(slot storage-type (type SYMBOL))
	(slot storage-speed (type INTEGER))
	(slot configurable (type STRING))
	(slot battery-life (type FLOAT))
	(slot os (type STRING))
	(slot warranty (type INTEGER))
	(slot colors (type STRING))
	(slot detachable (type SYMBOL)))

; Template for user requirements.
(deftemplate MAIN::laptop-requirement
	(slot id (type SYMBOL) (default REQ))
	(multislot brand (type SYMBOL) (default none))
	(multislot model (type SYMBOL) (default none))
	(slot price-upper (type FLOAT) (default 1000000.0))
	(slot screen-size-lower (type FLOAT) (default 0.0))
	(slot screen-size-upper (type FLOAT) (default 100.0))
	(slot is-fhd (type SYMBOL) (default none))
	(slot is-ultra-hd (type SYMBOL) (default none))
	(slot is-touchable (type SYMBOL) (default none))
	(slot weight-lower (type FLOAT) (default 0.0))
	(slot weight-upper (type FLOAT) (default 10.0))
	(slot cpu-class-lower (type INTEGER) (default 0))
	(slot cpu-class-upper (type INTEGER) (default 5))
	(slot memory-lower (type INTEGER) (default 0))
	(slot memory-upper (type INTEGER) (default 128))
	(multislot memory-type (type STRING) (default "none"))
	(slot gpu-class-lower (type INTEGER) (default 0))
	(slot gpu-class-upper (type INTEGER) (default 2))
	(slot has-discrete-graphic-card (type SYMBOL) (default none))
	(slot storage-size-lower (type INTEGER) (default 0))
	(slot storage-size-upper (type INTEGER) (default 4096))
	(multislot storage-type (type SYMBOL) (default none))
	(slot battery-life-lower (type FLOAT) (default 0.0))
	(multislot os (type STRING) (default "none"))
	(slot warranty-lower (type INTEGER) (default 0))
	(multislot colors (type STRING) (default "none"))
	(slot detachable (type SYMBOL) (default none))
	(slot is-ansd (type SYMBOL)(default N))
)

; Template for questions.
(deftemplate MAIN::qn-dscpt
	(slot id (type INTEGER))
	(slot content (type STRING))
)

; Template for questions.
(deftemplate MAIN::qn-ans
	(slot id (type INTEGER))
	(slot ans (default NIL))
	(slot converted (type SYMBOL)(default N))
)

;;;*************************
;;;* ASK GENERAL QUESTIONS *
;;;*************************

(defrule MAIN::ask-qn
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 10))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

; Update user requirements based on user input.
; Convert quenstion of user purpose.
(defrule MAIN::q0-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 0)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
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

; Convert quenstion of price requirement.
(defrule MAIN::q1-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 1)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(modify ?req(price-upper ?a))
)

; Convert quenstion of screen size requirement.
(defrule MAIN::q2-convert
	?req <- (laptop-requirement)
	?qn <- (qn-ans(id 2)(ans ?a)(converted N))
	(test (neq ?a NIL))
	=>
	(modify ?qn(converted Y))
	(if (= ?a 1) then
		(modify ?req(screen-size-upper 12.0))
	else (if (= ?a 2) then
		(modify ?req(screen-size-lower 12.0) (screen-size-upper 14))
	else (if (= ?a 3) then
		(modify ?req(screen-size-lower 14))
	)))
)

; Convert quenstion of screen resolution.
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

;;;*************************
;;;* PRINT RECOMMENDATIONS *
;;;*************************

; Prepare to print.
(defrule MAIN::print-prepare
	(output (id test) (is-finished Y))
	(not (print-laptop))
	=>
	(assert (print-begin))
)

(deffunction MAIN::print-models
	($?models)
	(printout t "Here are the models recommended for you:" crlf)
	(foreach ?model $?models
		(printout t ?model-index ". " ?model crlf)
	)
	(printout t crlf)
)

(deffunction MAIN::print-models-index
	($?models)
	(foreach ?model $?models
		(printout t ?model-index "[" ?model-index "]")
	)
)

; Print information when not matching results.
(defrule MAIN::print-nothing
	?fact <- (print-begin)
	(output (id test) (is-finished Y) (model $?models))
	(test (= (length $?models) 1))
	(test (eq (nth$ 1 $?models) "none"))
	=>
	(printout t "There are no recommended laptop matches.<opt>0[Restart session]</end>")
	(bind ?a (read-number))
	(if (eq ?a 0) then
		(reset)
		(run)
	)
)

; Print recommended data when there are possible recommendations.
(defrule MAIN::print-start
	?output <- (output (id test) (is-finished Y) (model $?models))
	?fact <- (print-begin)
	(not (print-laptop))
	(test (>= (length $?models) 1))
	(test (neq (nth$ 1 $?models) "none"))
	=>
	(print-models (delete-member$ $?models "none"))
	(bind ?tmp-str (format t "Which laptop would you want to view the detail?<opt>"))
	(print-models-index (delete-member$ $?models "none"))
	(bind ?tmp-str (format t "0[Restart session]</end>"))
	(bind ?a (read-number))
	(if (eq ?a 0) then
		(reset)
		(run)
	else
		(assert (print-laptop))
		(retract ?fact)
		(bind ?laptop (nth$ ?a $?models))
		(modify ?output(id test) (is-finished Y) (model $?models) (for-print ?laptop))
	)
)

; Print user details.
(deffunction MAIN::print-laptop-detail
	(?laptop)
	(printout t 
		" " (fact-slot-value ?laptop model)
		crlf (fact-slot-value ?laptop os)
		", " (fact-slot-value ?laptop memory) "GB RAM"
		crlf (fact-slot-value ?laptop screen-size) "\""
		" " (fact-slot-value ?laptop screen-resolution-x)
		"x" (fact-slot-value ?laptop screen-resolution-y)
		crlf (fact-slot-value ?laptop gpu)
		crlf (fact-slot-value ?laptop storage-size)
		" " (fact-slot-value ?laptop storage-type)
		crlf "~" (fact-slot-value ?laptop battery-life) "h battery life"
		crlf "$" (fact-slot-value ?laptop price)
	crlf)
)

(defrule MAIN::print-info
	?fact <- (print-laptop)
	?output <- (output (id test) (is-finished Y) (for-print ?forprint))
	?laptop <- (laptop (model ?model&:(eq ?model ?forprint)))
	(test (neq ?forprint NIL))
	=>
	(print-laptop-detail ?laptop)
	(printout t "<opt>1[Done]</end>")
	(bind ?a (read-number))
	(retract ?fact)
	(assert (print-begin))
)

;;;*****************
;;;* INITIAL FACTS *
;;;*****************

(deffacts MAIN::load-question-descriptions
	(qn-dscpt(id 0)(content "Why do you want a new computer?<opt>
			1[Office work]
			2[Entertainment]
			3[Web Browsing]
			4[Development]
			5[Gaming]</end>"))
	(qn-dscpt(id 1)(content "How much are you willing to pay for your new computer?</end>"))
	(qn-dscpt(id 2)(content "How big do you want your screen size to be (in inch)?<opt>
		1[12 or smaller]   2[about 13]   3[14 or larger]    4[don't care]</end>"))
	(qn-dscpt(id 3)(content "Which screen resolution do you prefer?<opt>
		1[FHD]    2[4K]    3[don't care]</end>"))
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
