; vim: ft=lisp et
(in-package :asdf)
(defsystem "with-cached-open-file"
  :version "0.1.4"
  :depends-on
  nil
  :pathname
  "src/"
  :components
  ((:file "with-cached-open-file")))

;; These forms below are added by JINGOH.GENERATOR.
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
(let ((system (find-system "jingoh.documentizer" nil)))
  (when system
    (load-system system)
    (defmethod operate :around
               ((o load-op) (c (eql (find-system "with-cached-open-file")))
                &key)
      (let* ((forms nil)
             (*macroexpand-hook*
              (let ((outer-hook *macroexpand-hook*))
                (lambda (expander form env)
                  (when (typep form '(cons (eql defpackage) *))
                    (push form forms))
                  (funcall outer-hook expander form env))))
             (*default-pathname-defaults*
              (merge-pathnames "spec/" (system-source-directory c))))
        (multiple-value-prog1 (call-next-method)
          (mapc (find-symbol (string :importer) :jingoh.documentizer)
                forms))))))
