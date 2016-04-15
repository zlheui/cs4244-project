; 3DGAME module
(defmodule 3DGAME
	(import MAIN ?ALL)
)

(defrule 3DGAME::ask-qn-3dgame
	?qn <- (qn-ans(id ?qn-id)(ans NIL))
	(qn-dscpt(id ?qn-id&:(< ?qn-id 60)&:(>= ?qn-id 50))(content ?qn-cnt))
	=>
	(printout t crlf)
	(bind ?tmp-str (format t ?qn-cnt))
	(bind ?a (read))
	(modify ?qn(ans ?a))
)

(defrule 3DGAME::focus-change
	(laptop-requirement)
	=>
	(focus 3DGAMEMATCH)
)

(deffacts 3DGAME::load-question-descriptions
)

(deffacts 3DGAME::test-qn-3DGAME
)
