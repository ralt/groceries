(in-package #:groceries)


;;;; Gets the list of all the items
(pm:defprepared items "select items()" :rows)

;;;; Adds an item in a list, returns the item id
;;;; $1 is the item name, $2 is the list id
(pm:defprepared add-item "select add_item($1, $2)" :none)

;;;; Gets all the items and their status in a list
(pm:defprepared list-items "select * from list_items($1)" :str-alists)

;;;; Sets the status in a list item
;;;; $1 is the list id, $2 is the item name, $3 is the new status
(pm:defprepared set-list-item-status "select set_list_item_status($1, $2, $3)" :none)

(defun get-item ()
  (with-db
    (jsown:to-json (a:flatten (items)))))

(defun post-item-add ()
  (let ((name (h:post-parameter "name")))
    (with-db
      (add-item name 1)
      "")))

(defun get-list-items ()
  (with-db
    (jsown:to-json (str-alists-to-jsown-json (list-items 1)))))

(defun post-set-list-item-status ()
  (let ((name (h:post-parameter "name"))
        (status (parse-integer (h:post-parameter "status") :junk-allowed t)))
    (with-db
      (set-list-item-status 1 name status)
      "")))
