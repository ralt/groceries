(in-package #:groceries)


(defvar *db-name* nil)
(defvar *db-user* nil)
(defvar *db-pass* nil)
(defvar *db-host* nil)
(defvar *db-port* nil)

;;;; Read the SQL contents to load them in the image
(defvar *db-folder*
  (merge-pathnames "sql/" (asdf:system-source-directory :groceries)))
(defvar *db-schema*
  (a:read-file-into-string (merge-pathnames "schema.sql" *db-folder*)))
(defvar *db-upgrades* (make-hash-table :test 'eq))
(loop
   :for i in '()
   :do (setf (gethash i *db-upgrades*)
             (a:read-file-into-string
              (merge-pathnames
               (concatenate 'string
                            (write-to-string i)
                            ".sql")
               (merge-pathnames "sql/upgrades/"
                                (asdf:system-source-directory :groceries))))))
(defvar *db-functions*
  (mapcar #'(lambda (name)
              (a:read-file-into-string
               (merge-pathnames
                (concatenate 'string name ".sql")
                *db-folder*)))
          '("schema_version"
            "items"
            "add_item"
            "list_items")))

(defmacro with-db (&body body)
  "postmodern:with-connection with db credentials."
  `(pm:with-connection (list *db-name* *db-user* *db-pass*
                             *db-host* :port *db-port* :pooled-p t)
     ,@body))

(pm:defprepared db-schema-exists "
SELECT EXISTS(
        SELECT *
        FROM information_schema.tables
        WHERE table_name = $1
        AND table_catalog = $2
)" :single)

(defun db-version ()
  (with-db
    (unless (db-schema-exists "db_version" *db-name*)
      (return-from db-version 0))
    (pm:query "SELECT schema_version()" :single)))

(defun db-upgrade (source dest)
  (loop
     :for i from (1+ source) upto dest
     :do (progn
           (format t "Running upgrade ~D...~%" i)
           (db-run (gethash i *db-upgrades*)
                   :multiqueries t))))

(defun db-initialize ()
  ;; schema is the only multi-queries file
  (db-run *db-schema* :multiqueries t)
  (dolist (func *db-functions*)
    (db-run func)))

(defun db-run (content &key (multiqueries nil))
  (with-db
    (if multiqueries
        (loop
           :for query in (cl-ppcre:split "-----" content)
           :do (pm:query query))
        (pm:query content))))

(defun str-alists-to-jsown-json (str-alists)
  (mapcar #'(lambda (item)
              `(:obj ,@item))
          str-alists))
