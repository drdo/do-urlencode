(cl:in-package :urlencode)

(declaim (ftype (function ((unsigned-byte 8)) character) octet-to-ascii))
(defun octet-to-ascii (octet)
  (aref (octets-to-string (make-array '(1)
                                      :element-type '(unsigned-byte 8)
                                      :initial-element octet)
                          :encoding :ASCII) 0))

(declaim (type (array (unsigned-byte 8) (4)) +extra-unreserved-octets+))
(defvar +extra-unreserved-octets+
  (make-array '(4) :element-type '(unsigned-byte 8)
              :initial-contents #(#x2D #x2E #x5F #x7E)))

(declaim (ftype (function ((unsigned-byte 8)) boolean) unreserved-octet-p))
(defun unreserved-octet-p (o)
  (or (<= #x30 o #x39) ; #\0 to #\9
      (<= #x41 o #x5A) ; #\A to #\Z
      (<= #x61 o #x7A) ; #\a to #\z
      (if (find o +extra-unreserved-octets+ :test #'=) t nil)))

(define-condition urlencode-malformed-string (error)
  ((string :initarg :string :reader urlencode-malformed-string-string))
  (:report (lambda (c stream)
             (format stream "The string ~s is not a valid urlencoded string."
                     (urlencode-malformed-string-string c)))))

(declaim (ftype (function (simple-string
                           &key (:queryp boolean))
                          simple-string)
                urlencode))
(defun urlencode (string &key (queryp nil))
  (loop
    with octets of-type (simple-array (unsigned-byte 8) (*)) = (string-to-octets string :encoding :UTF-8)
    with result = (make-string (* 3 (length octets)))
    for o across octets
    with i of-type fixnum = 0
    do (flet ((push-char (c)
                (setf (aref result i) c)
                (incf i)))
         (cond ((unreserved-octet-p o)
                (push-char (octet-to-ascii o)))
               ((and queryp (= o #x20))
                (push-char #\+))
               (t (let ((h (digit-char (ash (dpb 0 (byte 4 0) o) -4) 16))
                        (l (digit-char (dpb 0 (byte 4 4) o) 16)))
                    (push-char #\%)
                    (push-char h)
                    (push-char l)))))
    finally (return (subseq result 0 i))))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declaim (ftype (function ((unsigned-byte 8)) (or null (unsigned-byte 8)))
                hex-to-octet))
(defun hex-to-octet (a)
  (cond ((<= #x30 a #x39) (- a #x30)) ; #\0 to #\9
        ((<= #x41 a #x46) (+ 10 (- a #x41))) ; #\A to #\Z
        ((<= #x61 a #x66) (+ 10 (- a #x61))))) ; #\a to #\z

(declaim (ftype (function ((simple-array (unsigned-byte 8) (*))
                           &key (:start fixnum))
                          (or null (unsigned-byte 8)))
                try-parse-hex-pair))
(defun try-parse-hex-pair (octets &key (start 0))
  (when (< (1+ start) (length octets))
    (when-let ((a_ (hex-to-octet (aref octets start)))
               (b_ (hex-to-octet (aref octets (1+ start)))))
      (+ (ash a_ 4) b_))))

(declaim (ftype (function (simple-string &key (:queryp boolean)) simple-string)
                urldecode))
(defun urldecode (string &key (queryp nil))
  (loop
    with input = (string-to-octets string :encoding :UTF-8)
    with length = (length input)
    with result = (make-array `(,length) :element-type '(unsigned-byte 8))
    for j of-type fixnum from 0
    for i of-type fixnum from 0 below length
    do (if-let ((_ (= (aref input i) #x25)) ; #\%
                (value (try-parse-hex-pair input :start (1+ i))))
         (progn (setf (aref result j) value)
                (incf i 2))
         (setf (aref result j)
               (if (and (= (aref input i) #x2B) queryp) ; #\+
                   #x20 ; #\Space
                   (aref input i))))
    finally (return (octets-to-string result :end j :encoding :UTF-8))))
