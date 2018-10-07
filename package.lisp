(cl:in-package :cl)

(defpackage :do-urlencode
  (:nicknames :urlencode)
  (:use :cl)
  (:import-from :babel :octets-to-string :string-to-octets)
  (:import-from :alexandria :if-let :when-let)
  (:export :urlencode-malformed-string :urlencode-malformed-string-string
           :urlencode :urldecode))
