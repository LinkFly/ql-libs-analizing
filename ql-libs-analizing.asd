(defpackage ql-libs-analizing-system
  (:use :cl :asdf))

(defsystem :ql-libs-analizing
  :depends-on (:quicklisp)
  :components ((:file "ql-libs-analizing")))
  
