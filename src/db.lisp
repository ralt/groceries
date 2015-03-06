(in-package #:groceries)


(defvar *db-name* (uiop:getenv "DBNAME"))
(defvar *db-user* (uiop:getenv "DBUSER"))
(defvar *db-pass* (uiop:getenv "DBPASS"))
(defvar *db-host* (uiop:getenv "DBHOST"))

(defmacro with-db (&body body)
  "postmodern:with-connection with db credentials."
  `(pm:with-connection (list *db-name* *db-user* *db-pass* *db-host* :pooled-p t)
     ,@body))

(pm:defprepared db-schema-exists "
SELECT EXISTS(
        SELECT *
        FROM information_schema.tables
        WHERE table_schema = $1
        AND table_name = $2
)" :single)

(defun db-version ()
  (with-db
    (unless (db-schema-exists *db-name* "db_version")
      (return-from db-version 0))
    (pm:query "SELECT schema_version()" :single)))

(defun db-upgrade (source dest)
  (loop
     :for i from (1+ source) upto dest
     :do (db-run (merge-pathnames
                  (concatenate 'string (write-to-string i) ".sql")
                  (merge-pathnames "sql/upgrades/"
                                   (asdf:system-source-directory :groceries))))))

(defun db-initialize ()
  (dolist (file (mapcar
                 #'(lambda (name)
                     (merge-pathnames
                      (concatenate 'string name ".sql")
                      (merge-pathnames "sql/" (asdf:system-source-directory :groceries))))
                 '("schema"
                   "schema_version")))
    (db-run file)))

(defun db-run (file)
  (with-db
    (pm:query (a:read-file-into-string file))))
