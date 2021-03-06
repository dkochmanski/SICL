(cl:in-package #:cleavir-ast-to-hir)

(defmethod compile-ast ((ast cleavir-ast:speed-ast) context)
  (compile-ast (cleavir-ast:child-ast ast)
	       (clone-context context
			      :speed-value (cleavir-ast:value ast))))

(defmethod compile-ast ((ast cleavir-ast:debug-ast) context)
  (compile-ast (cleavir-ast:child-ast ast)
	       (clone-context context
			      :debug-value (cleavir-ast:value ast))))

(defmethod compile-ast ((ast cleavir-ast:safety-ast) context)
  (compile-ast (cleavir-ast:child-ast ast)
	       (clone-context context
			      :safety-value (cleavir-ast:value ast))))

(defmethod compile-ast ((ast cleavir-ast:space-ast) context)
  (compile-ast (cleavir-ast:child-ast ast)
	       (clone-context context
			      :space-value (cleavir-ast:value ast))))

(defmethod compile-ast ((ast cleavir-ast:compilation-speed-ast) context)
  (compile-ast (cleavir-ast:child-ast ast)
	       (clone-context context
			      :compilation-speed-value (cleavir-ast:value ast))))
