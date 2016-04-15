; 3DGAMEMATCH module

(defmodule 3DGAMEMATCH
	(import MAIN ?ALL)
	(import DATASET ?ALL)
)

(defrule 3DGAMEMATCH::mark-finish
	?output <- (output (id test))
	=>
	(modify ?output(is-finished Y))
)

(defrule 3DGAMEMATCH::matchlaptop
	(laptop-requirement 
		(price-upper ?price-upper) 
		(screen-size-lower ?ssl) 
		(screen-size-upper ?ssu) 
		(is-fhd ?is-fhd) 
		(is-ultra-hd ?is-ultra-hd))
		
	?laptop <- (laptop 
		(model ?model)
		(has-discrete-graphic-card Y)
		(memory ?memo&:(>= ?memo 8))
		(cpu-class ?cpu&:(>= ?cpu 4))
		(gpu-class ?gpu&:(>= ?gpu 2)) 
		(storage-size ?storage-size&:(>= ?storage-size 512)) 
		(price ?price&:(>= ?price-upper ?price)) 
		(screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu))) 
		(is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y)))) 
		(is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none) (and (eq ?is-ultra-hd Y) (eq ?is-ultra-hd-laptop Y)))))
	?output <- (output (id test) (is-finished Y) (model $?models))
	=>
	(if (eq (nth$ 1 $?models) "none") 
	then
		(bind ?var (create$ ?model))
		(modify ?output(model ?var))
	else
		(bind ?var (insert$ $?models 1 ?model))
		(modify ?output(model ?var))
	)
	; (printout t ?model crlf)
	(retract ?laptop)
)
