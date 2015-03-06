(in-package #:groceries)


(defvar *debug* t)

;;;; List of routes
(setf
 h:*dispatch-table*
 (list
  (h:create-regex-dispatcher "^/$" #'home)))

;;;; h basic handling
(defvar *server* nil)

(defun start (&optional (port 4242))
  (setf *server*
        (h:start
         (make-instance
          'h:easy-acceptor :port port
          :document-root (merge-pathnames
                          #p"static/"
                          (asdf:system-source-directory :groceries))))))

(defun stop (&optional (soft t))
  (h:stop *server* :soft soft))

;;;; cl-who options (well, option)
(setf (who:html-mode) :html5)

;;;; db version
(defvar *version* 1)

(block db-init
  (let ((db-version (db-version)))
    (when (= db-version 0)
      (return-from db-init (db-initialize)))
    (when (= *version* db-version)
      (return-from db-init (format t "Database version up-to-date.~%")))
    (when (> *version* db-version)
      (return-from db-init (db-upgrade db-version *version*)))
    (when (< *version* db-version)
      (format t "Database version more recent than code version. Terminating.~%")
      (unless *debug*
        (uiop:quit -1)))))
