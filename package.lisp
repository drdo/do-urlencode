(cl:in-package :cl)

(defpackage :do-urlencode
  (:nicknames :urlencode)
  (:use :cl :babel :babel-streams)
  (:export :urlencode-malformed-string :urlencode-malformed-string-string
           :urlencode :urldecode))
