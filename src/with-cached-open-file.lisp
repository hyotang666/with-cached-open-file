(in-package :cl-user)
(defpackage :with-cached-open-file
  (:use :cl)
  (:export))
(in-package :with-cached-open-file)

(let((>cache<(make-hash-table :test #'equal)))
  ;; as type of { string : (cons fixnum t) }
  (defun call-with-cached-open-file(path thunk)
    (flet((read-with-cache(path)
	    (let((contents(funcall thunk)))
	      (setf (gethash (namestring path)>cache<)
		    (cons (uiop:safe-file-write-date path)
			  contents))
	      contents)))
      (let((cache(gethash (namestring path)>cache<)))
	(if(null cache)
	  (read-with-cache path)
	  (if(uiop:timestamp< (car cache)
			      (uiop:safe-file-write-date path))
	    (read-with-cache path)
	    (cdr cache)))))))

(defmacro with-cached-open-file((stream path &rest params)&body body)
  (let((gpath(gensym"PATHNAME")))
    `(let((,gpath ,path))
       (call-with-cached-open-file
	 ,gpath
	 (lambda()
	   (with-open-file(,stream ,gpath ,@params)
	     ,@body))))))

#++
(let((path(asdf:system-source-file(asdf:find-system :with-cached-open-file))))
  (flet((doit()
	  (with-cached-open-file(s path)
	    (loop :for line = (read-line s nil nil)
		  :while line
		  :collect line :into lines
		  :finally (return(apply #'concatenate 'string lines))))))
    (time (doit))
    (time (doit))
    (print (uiop:safe-file-write-date path))
    (uiop:run-program(format nil "touch ~A" path))
    (print (uiop:safe-file-write-date path))
    (time(doit))))
