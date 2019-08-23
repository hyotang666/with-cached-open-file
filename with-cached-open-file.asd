; vim: ft=lisp et
(in-package :asdf)
(defsystem "with-cached-open-file"
  :version "0.0.0"
  :depends-on
  nil
  :pathname
  "src/"
  :components
  ((:file "with-cached-open-file")))

;; These two methods below are added by JINGOH.GENERATOR.
(in-package :asdf)
(defmethod component-depends-on
           ((o test-op) (c (eql (find-system "with-cached-open-file"))))
  (append (call-next-method) '((test-op "with-cached-open-file.test"))))
(defmethod operate :around
           ((o test-op) (c (eql (find-system "with-cached-open-file")))
            &rest keys
            &key ((:compile-print *compile-print*))
            ((:compile-verbose *compile-verbose*)) &allow-other-keys)
  (flet ((jingoh.args (keys)
           (loop :for (key value) :on keys :by #'cddr
                 :when (find key '(:on-fails :subject :vivid) :test #'eq)
                 :collect key
                 :and
                 :collect value :else
                 :when (eq :jingoh.verbose key)
                 :collect :verbose
                 :and
                 :collect value)))
    (let ((args (jingoh.args keys)))
      (declare (special args))
      (call-next-method))))
