; CASUALGAMEMATCH module

(defmodule CASUALGAMEMATCH
	(import MAIN ?ALL)
)

(deffacts CASUALGAMEMATCH::facts
	(laptop(model lenovo-Y470) (price 1000.0) (screen-size 17.0) (has-discrete-graphic-card N) (memory 4) (is-touchable Y) (detachable Y) (storage-size 256) (cpu "low") (gpu "low"))
	(laptop(model lenovo-Y570) (price 1000.0) (screen-size 17.0) (has-discrete-graphic-card N) (memory 8) (storage-size 256) (detachable Y) (is-touchable Y) (cpu "low") (gpu "low"))
;	more facts
)

(defrule CASUALGAMEMATCH::matchlaptop
	(laptop-requirement (price-upper ?price-upper) (screen-size-lower ?ssl) (screen-size-upper ?ssu) (is-fhd ?is-fhd) (is-ultra-hd ?is-ultra-hd) (is-touchable ?is-touchable) (detachable ?detachable))
	
	?laptop <- (laptop (model ?model)(has-discrete-graphic-card N) (memory ?memo&:(and (>= ?memo 2) (<= ?memo 8) )) (cpu ?cpu&:(eq ?cpu "low")) (gpu ?gpu&:(eq ?gpu "low")) (storage-size ?storage-size&:(and (>= ?storage-size 128) (<= ?storage-size 512))) (price ?price&:(>= ?price-upper ?price)) (screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu))) (is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y)))) (is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none) (and (eq ?is-ultra-hd Y) (eq ?is-ultra-hd-laptop Y)))) (is-touchable ?is-touchable-laptop&:(or (eq ?is-touchable none) (and (eq ?is-touchable Y) (eq ?is-touchable-laptop Y)))) (detachable ?detachable-laptop&:(or (eq ?detachable none) (and (eq ?detachable Y) (eq ?detachable-laptop Y)))))
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