(in-package #:groceries)


;;;; Gets the list of all the items
(pm:defprepared items "select items()" :rows)

;;;; Adds an item in a list, returns the item id
;;;; $1 is the item name, $2 is the list id
(pm:defprepared add-item "select add_item($1, $2)" :single)

(defun get-item ()
  (with-db
    (jsown:to-json (a:flatten (items)))))

(defun post-item-add ()
  (let ((name (h:post-parameter "name")))
    (with-db
      (write-to-string (add-item name 1)))))
