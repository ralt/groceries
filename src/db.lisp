(in-package #:groceries)


(defvar *db-name* (uiop:getenv "DBNAME"))
(defvar *db-user* (uiop:getenv "DBUSER"))
(defvar *db-pass* (uiop:getenv "DBPASS"))
(defvar *db-host* (uiop:getenv "DBHOST"))
(defvar *db-port* (or (uiop:getenv "DBPORT") 5432))

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
           (db-run (merge-pathnames
                    (concatenate 'string (write-to-string i) ".sql")
                    (merge-pathnames "sql/upgrades/"
                                     (asdf:system-source-directory :groceries)))))))

(defun db-initialize ()
  ;; schema is the only multi-queries file
  (db-run (merge-pathnames
           "schema.sql"
           (merge-pathnames "sql/" (asdf:system-source-directory :groceries)))
          :multiqueries t)
  (dolist (file (mapcar
                 #'(lambda (name)
                     (merge-pathnames
                      (concatenate 'string name ".sql")
                      (merge-pathnames "sql/" (asdf:system-source-directory :groceries))))
                 '("schema_version"
                   "items"
                   "add_item"
                   "list_items")))
    (db-run file)))

(defun db-run (file &key (multiqueries nil))
  (with-db
    (if multiqueries
        (loop
           :for query in (cl-ppcre:split ";" (a:read-file-into-string file))
           :do (pm:query query))
        (pm:query (a:read-file-into-string file)))))
