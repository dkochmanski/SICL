(cl:in-package #:cleavir-ast-graphviz)

;;;; Drawing an AST. 
;;;;
;;;; We generate a Graphviz source file from the AST so that the AST
;;;; can be presented in graph form for easy inspection.

(defparameter *table* nil)

(defun id (ast)
  (symbol-name (gethash ast *table*)))

(defgeneric stream-draw-ast (ast stream))

(defun draw-ast (ast filename)
  (with-open-file (stream filename :direction :output :if-exists :supersede)
    (format stream "digraph G {~%   ordering = out;~%")
    (let ((*table* (make-hash-table :test #'eq)))
      (stream-draw-ast ast stream))
    (format stream "}~%")))

(defmethod stream-draw-ast :around (ast stream)
  (when (null (gethash ast *table*))
    (setf (gethash ast *table*) (gensym))
    (format stream "  ~a [shape = box];~%"
	    (id ast))
    (call-next-method)
    (loop for child in (children ast)
	  for i from 1
	  do (stream-draw-ast child stream)
	     (format stream "   ~a -> ~a [label = \"~d\"];~%"
		     (id ast) (id child) i))))

(defgeneric label (ast))

;;; The default label is the lower-case version of the name of the
;;; class (as a string) with suffix -ast stripped off. 
(defmethod label (ast)
  (let ((name (string (class-name (class-of ast)))))
    (string-downcase (subseq name 0 (- (length name) 4)))))

(defmacro deflabel (ast label)
  `(defmethod label ((ast ,ast))
     (declare (ignorable ast))
     ,label))

;;; Default method on STREAM-DRAW-AST.  This method simply calls the
;;; generic function LABEL in order to draw a label for the box.
(defmethod stream-draw-ast (ast stream)
  (format stream "   ~a [label = \"~a\"];~%"
	  (id ast) (label ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a CONSTANT-AST.

(defmethod stream-draw-ast ((ast constant-ast) stream)
  (format stream "   ~a [style = filled, fillcolor = green];~%" (id ast))
  (format stream "   ~a [label = \"~a\"];~%"
	  (id ast)
	  (value ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a LEXICAL-AST.

(defmethod stream-draw-ast ((ast lexical-ast) stream)
  (format stream "   ~a [style = filled, fillcolor = yellow];~%" (id ast))
  (format stream "   ~a [label = \"~a\"];~%"
	  (id ast)
	  (name ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a TAG-AST.

(defmethod stream-draw-ast ((ast tag-ast) stream)
  (format stream "   ~a [label = \"~a\"];~%"
	  (id ast)
	  (name ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a TOP-LEVEL-FUNCTION-AST.

(defmethod stream-draw-ast ((ast top-level-function-ast) stream)
  (format stream "   ~a [label = \"~a ~a\"];~%"
	  (id ast)
	  (label ast)
	  (forms ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a LOAD-TIME-VALUE-AST.

(defmethod stream-draw-ast ((ast load-time-value-ast) stream)
  (format stream "   ~a [label = \"~a\"];~%"
	  (id ast) (form ast))
  (format stream "   ~a [style = filled, fillcolor = pink];~%"
	  (id ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a BIND-AST.

(defmethod stream-draw-ast ((ast bind-ast) stream)
  (format stream "   ~a [shape = box, label = \"bind\"];~%"
	  (id ast))
  (let ((symbol-id (gensym)))
    (format stream "   ~a [shape = ellipse, label = \"~a\"];~%"
	    symbol-id (symbol ast))
    (format stream "   ~a -> ~a [label = \"0\"];~%"
	    (id ast) symbol-id)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Drawing a THE-AST.

(defmethod stream-draw-ast ((ast the-ast) stream)
  (format stream "   ~a [label = \"the (values ~@[~s~] ~@[&optional ~s~] &rest ~s\"];~%"
	  (id ast)
	  (cleavir-ast:required-types ast)
	  (cleavir-ast:optional-types ast)
	  (cleavir-ast:rest-type ast)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Labels for unspecialized array ASTs

(deflabel simple-t-aref-ast "simple t aref")
(deflabel simple-t-aset-ast "simple t aset")
(deflabel non-simple-t-aref-ast "non-simple t aref")
(deflabel non-simple-t-aset-ast "non-simple t aset")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Labels for floating-point ASTs

(deflabel short-float-add-ast "shf +")
(deflabel short-float-sub-ast "shf -")
(deflabel short-float-mul-ast "shf *")
(deflabel short-float-div-ast "shf /")
(deflabel short-float-less-ast "shf <")
(deflabel short-float-not-greater-ast "shf <=")
(deflabel short-float-greater-ast "shf >")
(deflabel short-float-not-less-ast "shf >=")
(deflabel short-float-equal-ast "shf =")
(deflabel short-float-sin-ast "shf sin")
(deflabel short-float-cos-ast "shf cos")
(deflabel short-float-sqrt-ast "shf sqrt")
(deflabel simple-short-float-aref-ast "simple shf aref")
(deflabel simple-short-float-aset-ast "simple shf aset")
(deflabel non-simple-short-float-aref-ast "non-simple shf aref")
(deflabel non-simple-short-float-aset-ast "non-simple shf aset")

(deflabel single-float-add-ast "sf +")
(deflabel single-float-sub-ast "sf -")
(deflabel single-float-mul-ast "sf *")
(deflabel single-float-div-ast "sf /")
(deflabel single-float-less-ast "sf <")
(deflabel single-float-not-greater-ast "sf <=")
(deflabel single-float-greater-ast "sf >")
(deflabel single-float-not-less-ast "sf >=")
(deflabel single-float-equal-ast "sf =")
(deflabel single-float-sin-ast "sf sin")
(deflabel single-float-cos-ast "sf cos")
(deflabel single-float-sqrt-ast "sf sqrt")
(deflabel simple-single-float-aref-ast "simple sf aref")
(deflabel simple-single-float-aset-ast "simple sf aset")
(deflabel non-simple-single-float-aref-ast "non-simple sf aref")
(deflabel non-simple-single-float-aset-ast "non-simple sf aset")

(deflabel double-float-add-ast "df +")
(deflabel double-float-sub-ast "df -")
(deflabel double-float-mul-ast "df *")
(deflabel double-float-div-ast "df /")
(deflabel double-float-less-ast "df <")
(deflabel double-float-not-greater-ast "df <=")
(deflabel double-float-greater-ast "df >")
(deflabel double-float-not-less-ast "df >=")
(deflabel double-float-equal-ast "df =")
(deflabel double-float-sin-ast "df sin")
(deflabel double-float-cos-ast "df cos")
(deflabel double-float-sqrt-ast "df sqrt")
(deflabel simple-double-float-aref-ast "simple df aref")
(deflabel simple-double-float-aset-ast "simple df aset")
(deflabel non-simple-double-float-aref-ast "non-simple df aref")
(deflabel non-simple-double-float-aset-ast "non-simple df aset")

(deflabel long-float-add-ast "lf +")
(deflabel long-float-sub-ast "lf -")
(deflabel long-float-mul-ast "lf *")
(deflabel long-float-div-ast "lf /")
(deflabel long-float-less-ast "lf <")
(deflabel long-float-not-greater-ast "lf <=")
(deflabel long-float-greater-ast "lf >")
(deflabel long-float-not-less-ast "lf >=")
(deflabel long-float-equal-ast "lf =")
(deflabel long-float-sin-ast "lf sin")
(deflabel long-float-cos-ast "lf cos")
(deflabel long-float-sqrt-ast "lf sqrt")
(deflabel simple-long-float-aref-ast "simple lf aref")
(deflabel simple-long-float-aset-ast "simple lf aset")
(deflabel non-simple-long-float-aref-ast "non-simple lf aref")
(deflabel non-simple-long-float-aset-ast "non-simple lf aset")

(deflabel simple-bit-aref-ast "simple bit aref")
(deflabel simple-bit-aset-ast "simple bit aset")
(deflabel non-simple-bit-aref-ast "non-simple bit aref")
(deflabel non-simple-bit-aset-ast "non-simple bit aset")
