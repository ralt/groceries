(in-package #:groceries)


(defun render-json (fn)
  (let ()
    (lambda ()
      (setf (h:content-type*) "application/json")
      (funcall fn))))
