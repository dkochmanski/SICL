(cl:in-package #:cleavir-ir)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Mixin classes for instructions according to successor count.

;;; Mixin class for instructions with no successors. 
(defclass no-successors-mixin () ())

;;; Mixin class for instructions with a single successor.
(defclass one-successor-mixin () ())

;;; Mixin class for instructions with tow successors.
(defclass two-successors-mixin () ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Other mixin classes.

;;; Mixin class for instructions that have side effects so that they
;;; should not be removed.
(defclass side-effect-mixin () ())
