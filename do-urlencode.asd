(cl:in-package :asdf)

(defsystem :do-urlencode
  :author "Daniel Rebelo de Oliveira <drdo@drdo.eu>"
  :maintainer "Daniel Rebelo de Oliveira <drdo@drdo.eu>"
  :description "Percent Encoding (aka URL Encoding) library"
  :depends-on (:alexandria :babel)
  :serial t
  :components ((:file "package")
	             (:file "urlencode")))
