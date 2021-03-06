(cl:in-package #:asdf-user)

(defsystem :cleavir-boolean-elimination
  :depends-on (:cleavir-simple-value-numbering)
  :serial t
  :components
  ((:file "packages")
   (:file "boolean-input-p")
   (:file "find-boolean-assignments")
   (:file "find-boolean-tests")))
