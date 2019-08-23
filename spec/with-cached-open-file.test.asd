; vim: ft=lisp et
(in-package :asdf)
(defsystem :with-cached-open-file.test
  :version "0.0.0"
  :depends-on
  (:jingoh "with-cached-open-file")
  :components
  ((:file "with-cached-open-file"))
  :perform
  (test-op (o c) (declare (special args))
   (apply #'symbol-call :jingoh :examine :with-cached-open-file args)))
