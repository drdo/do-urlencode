(cl:in-package :asdf)

(defsystem :do-urlencode
  :author "Daniel Oliveira <drdo@drdo.eu>"
  :maintainer "Daniel Oliveira <drdo@drdo.eu>"
  :depends-on (:babel :babel-streams)
  :serial t
  :components ((:file "package")
	       (:file "urlencode")))
