; 3DGAMEMATCH module

(defmodule 3DGAMEMATCH
	(import MAIN deftemplate laptop laptop-requirement)
)

(deffacts 3DGAMEMATCH::facts
	(laptop(model lenovo-Y470) (price 1000.0) (screen-size 17.0) (has-discrete-graphic-card Y) (memory 16) (storage-size 1024) (cpu "high") (gpu "high"))
	(laptop(model lenovo-Y570) (price 1000.0) (has-discrete-graphic-card Y) (memory 16) (storage-size 1024) (is-ultra-hd Y) (cpu "high") (gpu "high"))
;	more facts
)

(defrule 3DGAMEMATCH::matchlaptop
	(laptop-requirement (price-upper ?price-upper) (screen-size-lower ?ssl) (screen-size-upper ?ssu) (is-fhd ?is-fhd) (is-ultra-hd ?is-ultra-hd))
	?laptop <- (laptop (model ?model)(has-discrete-graphic-card Y) (memory ?memo&:(>= ?memo 8)) (cpu ?cpu&:(eq ?cpu "high")) (storage-size ?storage-size&:(>= ?storage-size 512)) (gpu ?gpu&:(eq ?gpu "high")) (price ?price&:(>= ?price-upper ?price)) (screen-size ?screen-size&:(and (>= ?screen-size ?ssl) (<= ?screen-size ?ssu))) (is-fhd ?is-fhd-laptop&:(or (eq ?is-fhd none) (and (eq ?is-fhd Y) (eq ?is-fhd-laptop Y)))) (is-ultra-hd ?is-ultra-hd-laptop&:(or (eq ?is-ultra-hd none) (and (eq ?is-ultra-hd Y) (eq ?is-ultra-hd-laptop Y)))))
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