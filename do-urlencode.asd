(cl:in-package :asdf)

(defsystem :do-urlencode
  :author "Daniel Oliveira <drdo@drdo.eu>"
  :maintainer "Daniel Oliveira <drdo@drdo.eu>"
  :description "Percent Encoding (aka URL Encoding) library"
  :depends-on (:babel :babel-streams)
  :serial t
  :components ((:file "package")
	       (:file "urlencode")))
