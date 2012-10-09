;(declaim (optimize (debug 3)))
(defpackage :ql-libs-analizing
  (:use :cl :asdf :ql)
  (:export #:create-ratings-hash #:get-sorted-ratings
	   #:get-subset-ratings #:print-ratings))

(in-package :ql-libs-analizing)

(defun get-all-systems ()
  "Get all quicklisp systems"
  (provided-systems t))

(defun create-sys-hash (&optional (systems (get-all-systems)) &aux sys-hash)
  "Filling sys-hash by system names"
  (setf sys-hash (make-hash-table :test 'equal))
  (dolist (system systems sys-hash)
    (setf (gethash (ql::name system) sys-hash) 0)))

(defun counting-references (sys-hash &optional (systems (get-all-systems)))
  "Counting references to systems"
  (dolist (system systems sys-hash)    
    (dolist (sys (ql::required-systems system))
      (when (string/= "asdf" sys)
	(incf (gethash sys sys-hash))))))
;(setf ratings (counting-references (create-ratings-hash)))

(defun create-ratings-hash ()
  "Create hash array with system ratings"
  (counting-references (create-sys-hash (get-all-systems))))
;(setf ratings (create-ratings-hash))
;(gethash "alexandria" ratings)

(defun cr-array-with-counts (sys-hash)
  "Create array with counts and sorting it"
  (loop :with ar = (make-array (hash-table-count sys-hash))
     :for sys-name :being :the :hash-key :in sys-hash
     :for i :from 0
     :do (setf (aref ar i) (list (gethash sys-name sys-hash)
				 sys-name))
     :finally (return ar)))
;(cr-array-with-counts (create-ratings-hash))

(defun get-sorted-ratings (&key (test #'<))
  "Get sorted array with system ratings"
  (sort (cr-array-with-counts (create-ratings-hash))
	test
	:key #'car))
;(get-sorted-ratings)

(defun get-subset-ratings (ratings-array max-rating)
  "Get all ratings greater or equal max-rating"
  (loop :for rating :across ratings-array
     :when (>= (first rating) max-rating)
     :collect rating))

(defun print-ratings (&optional (max-rating 0))
  "Print all system ratings or all of the greater or equal max-rating"
  (loop :for rating :in (get-subset-ratings (get-sorted-ratings :test #'<) 
					    max-rating)
     :do (print rating)))
;(print-ratings)
;(print-ratings 40)
