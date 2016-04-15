; OFFICE-MATCH module

(defmodule OFFICE-MATCH
	(import MAIN deftemplate laptop laptop-requirement)
	(import DATASET ?ALL)
)

(defrule OFFICE-MATCH::match-office-laptop
	(laptop-requirement
		(price-upper ?price-upper) 
		(screen-size-lower ?ssl) (screen-size-upper ?ssu) 
		(is-fhd ?is-fhd) (is-ultra-hd ?is-ultra-hd)
		(weight-upper ?weight-upper)
		(battery-life-lower ?bt-lower)
	)
	?laptop <- (laptop
		(model ?model)
		(has-discrete-graphic-card N)
		(memory ?memo&:(>= ?memo 2))
		(cpu-class ?cpu&:(<= ?cpu 3))
		(gpu-class ?gpu&:(<= ?gpu 1))
		(storage-size ?storage-size&:(>= ?storage-size 128))
		(price ?price&:(<= ?price ?price-upper))
		(screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu)))
		(is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y))))
		(is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none)(and (eq ?is-ultra-hd Y)(eq ?is-ultra-hd-laptop Y))))
		(weight ?weight&:(<= ?weight ?weight-upper))
		(battery-life ?bt-life&:(>= ?bt-life ?bt-lower))
	)
	?output <- (output (id test) (model $?models))
	=>
	(if (eq (nth$ 1 $?models) none)
	then
		(bind ?var (create$ ?model))
		(modify ?output(model ?var))
	else
		(bind ?var (insert$ $?models 1 ?model))
		(modify ?output(model ?var))
	)
	(printout t ?model crlf)
	(retract ?laptop)
)