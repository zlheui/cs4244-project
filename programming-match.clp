; PROGRAMMING-MATCH module

(defmodule PROGRAMMING-MATCH
	(import MAIN deftemplate laptop laptop-requirement)
)

(deffacts PROGRAMMING-MATCH::facts
	(laptop(model lenovo-Y470) (price 1000.0) (screen-size 17.0) (has-discrete-graphic-card Y) (memory 16) (storage-size 1024) (cpu "high") (gpu "high"))
	(laptop(model lenovo-Y570) (price 1000.0) (has-discrete-graphic-card Y) (memory 16) (storage-size 1024) (is-ultra-hd Y) (cpu "high") (gpu "high"))
;	more facts
)

(defrule PROGRAMMING-MATCH::match-office-laptop
	(laptop-requirement 
		(price-upper ?price-upper) 
		(screen-size-lower ?ssl) (screen-size-upper ?ssu) (is-fhd ?is-fhd) (is-ultra-hd ?is-ultra-hd)
		(weight-upper ?weight-upper)
		(battery-life-lower ?bt-lower)
		(os ?os)
	)
	?laptop <- (laptop 
		(model ?model)
		(has-discrete-graphic-card Y) 
		(memory ?memo&:(>= ?memo 2))
		(storage-size ?storage-size&:(>= ?storage-size 128))
		(price ?price&:(<= ?price ?price-upper))
		(screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu)))
		(is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y))))
		(is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none)(and (eq ?is-ultra-hd Y)(eq ?is-ultra-hd-laptop Y))))
		(weight ?weight&:(<= ?weigh ?weight-upper))
		(battery-life ?bt-life&:(<= ?bt-life ?bt-lower))
		(os ?laptop-os&:(or (eq ?os none)(and (eq ?laptop-os ?os))))
	)
	?output <- (output (id test) (model $?models))
	=>
	(if (eq (nth$ 1 $?models) none) 
	then
		(bind ?var (create$ ?model))
		(modify ?output(model ?var))
		(printout t "1" ?var crlf)
	else
		(bind ?var (insert$ $?models 1 ?model))
		(modify ?output(model ?var))
		(printout t "2" ?var crlf)
	)
	(retract ?laptop)
)