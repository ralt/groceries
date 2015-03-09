(in-package #:groceries)


(defvar *debug* nil)

;;;; List of routes
(setf
 h:*dispatch-table*
 (list
  (h:create-regex-dispatcher "^/$" #'home)
  (h:create-regex-dispatcher "^/item$" (render-json #'get-item))
  (h:create-regex-dispatcher "^/item/add$" (render-json #'post-item-add))
  (h:create-regex-dispatcher "^/item/list$" (render-json #'get-list-items))
  (h:create-regex-dispatcher "^/item/status$" #'post-set-list-item-status)
  (h:create-regex-dispatcher "^/list/clear$" #'post-list-clear)))

;;;; hunchentoot basic handling
(defvar *server* nil)

(defun start (&optional (port 4242) (address "localhost"))
  (setf *server*
        (h:start
         (make-instance
          'h:easy-acceptor :port port :address address
          :document-root (or
                          (uiop:getenv "DOCUMENT_ROOT")
                          (merge-pathnames
                           #p"static/"
                           (asdf:system-source-directory :groceries)))))))

(defun stop (&optional (soft t))
  (h:stop *server* :soft soft))

;;;; cl-who options (well, option)
(setf (who:html-mode) :html5)

;;;; db version
(defvar *version* 1)

(defun db-init ()
  (setf *db-name* (uiop:getenv "DBNAME"))
  (setf *db-user* (uiop:getenv "DBUSER"))
  (setf *db-pass* (uiop:getenv "DBPASS"))
  (setf *db-host* (uiop:getenv "DBHOST"))
  (setf *db-port* (or (parse-integer (uiop:getenv "DBPORT")) 5432))
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

(defun main (&rest args)
  (declare (ignore args))
  (db-init)
  (start (parse-integer (uiop:getenv "PORT")) (uiop:getenv "ADDRESS"))
  (sb-impl::toplevel-repl nil))
