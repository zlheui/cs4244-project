; CASUALGAMEMATCH module

(defmodule CASUALGAMEMATCH
	(import MAIN ?ALL)
	(import DATASET ?ALL)
)

(defrule CASUALGAMEMATCH::mark-finish
	?output <- (output (id test) (is-finished N))
	=>
	(modify ?output(is-finished Y))
)

(defrule CASUALGAMEMATCH::matchlaptop
	(laptop-requirement 
		(price-upper ?price-upper) 
		(screen-size-lower ?ssl) 
		(screen-size-upper ?ssu) 
		(is-fhd ?is-fhd) 
		(is-ultra-hd ?is-ultra-hd) 
		(is-touchable ?is-touchable) 
		(detachable ?detachable))
	
	?laptop <- (laptop 
		(model ?model)
		(has-discrete-graphic-card N) 
		(memory ?memo&:(and (>= ?memo 2) (<= ?memo 8))) 
		(cpu-class ?cpu&:(<= ?cpu 1)) 
		(gpu-class ?gpu&:(<= ?gpu 1)) 
		(storage-size ?storage-size&:(and (>= ?storage-size 32) (<= ?storage-size 256))) 
		(price ?price&:(>= ?price-upper ?price)) 
		(screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu))) 
		(is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y)))) 
		(is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none) (and (eq ?is-ultra-hd Y) (eq ?is-ultra-hd-laptop Y)))) 
		(is-touchable ?is-touchable-laptop&:(or (eq ?is-touchable none) (eq ?is-touchable ?is-touchable-laptop))) 
		(detachable ?detachable-laptop&:(or (eq ?detachable none) (eq ?detachable ?detachable-laptop))))
	?output <- (output (id test) (is-finished Y) (model $?models))
	(test (not (member$ ?model $?models)))
	=>
	(if (eq (nth$ 1 $?models) "none") 
	then
		(bind ?var (create$ ?model))
		(modify ?output(model ?var))
	else
		(bind ?var (insert$ $?models 1 ?model))
		(modify ?output(model ?var))
	)
)
