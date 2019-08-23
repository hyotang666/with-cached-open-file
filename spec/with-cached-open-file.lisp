(defpackage :with-cached-open-file.spec
  (:use :cl :jingoh :with-cached-open-file))
(in-package :with-cached-open-file.spec)
(setup :with-cached-open-file)

(requirements-about WITH-CACHED-OPEN-FILE :doc-type function)

;;;; Description:
; Almost same with CL:WITH-OPEN-FILE, but memoised result.
; BODY is evaluated only file is updated.

#+syntax
(WITH-CACHED-OPEN-FILE (stream path &rest params) &body body) ; => result

;;;; Arguments and Values:

; stream := SYMBOL as var, otherwise signals an error.
#?(with-cached-open-file("not symbol" "dummy")"dummy body")
:signals error
; Not evaluated.
#?(with-cached-open-file((intern "not evaluated")"dummy path")
    "dummy body")
:signals error

; path := pathname designator, otherwiwe error.
#?(with-cached-open-file(*standard-input* '(not path name))
    "dummy body")
:signals error
,:lazy t
,:ignore-signals warning

; Evaluated.
#?(with-cached-open-file(*standard-input* no-such-var)
    "dummy body")
:signals (or error
	     warning ; for ccl
	     )

; params := Almost same with CL:OPEN, but :direction.
; When :direction is specified, and it is :output,
; an error is signaled.
#?(with-cached-open-file(dummy "dummy/path" :direction :output)
    "dummy body")
:signals error

; body := implicit progn.

; result := T
; multiple-value is supported.
#?(let((path
	 (merge-pathnames "test"
			  (asdf:system-source-directory
			    (asdf:find-system :with-cached-open-file)))))
    (multiple-value-call #'list
      (with-open-file(s path
			:direction :output
			:if-exists :error
			:if-does-not-exist :create)
	(print 2 s))
      (with-cached-open-file(s path)
	(floor 3 (read s)))
      (with-cached-open-file(s path)
	(floor 3 (read s)))))
=> (2 1 1 1 1)
,:test equal
,:after (delete-file(merge-pathnames "test"
				     (asdf:system-source-directory
				       (asdf:find-system :with-cached-open-file))))

;;;; Affected By:
; State of filesystem.

;;;; Side-Effects:
; Refer file.

;;;; Notes:
; CL:FILE-WRITE-DATE return universal-time.
; This means the second is its accuracy.
; When your machine's I/O is too much fast,
; cached value is return even if file is updated.

;;;; Exceptional-Situations:

;;;; Example
#?(let((path
	 (merge-pathnames "test2"
			  (asdf:system-source-directory
			    (asdf:find-system :with-cached-open-file)))))
    (values
      (with-open-file(s path :direction :output :if-exists :error
			:if-does-not-exist :create)
	(print "a" s))

      ;; Each READ newly allocates string, so pointer-eq fails.
      (eq (with-open-file(s path)
	    (read s))
	  (with-open-file(s path)
	    (read s)))

      ;; First form newly allocates string but second one return cached value,
      ;; so pointer-eq success.
      (eq (with-cached-open-file(s path)
	    (read s))
	  (with-cached-open-file(s path)
	    (read s)))

      (with-cached-open-file(s path)
	(read s))
      (progn (sleep 1)
	     (with-open-file(s path :direction :output :if-exists :supersede
			       :if-does-not-exist :error)
	       (print "b" s))
	     (with-cached-open-file(s path)
	       (read s)))))
:values ("a"
	 NIL
	 T
	 "a"
	 "b")
,:timeout 10
,:after (delete-file(merge-pathnames "test2"
				     (asdf:system-source-directory
				       (asdf:find-system :with-cached-open-file))))
