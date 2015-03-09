(in-package #:groceries)


;;;; Gets all the items and their status in a list
(pm:defprepared list-items "select * from list_items($1)" :str-alists)

;;;; Sets the status in a list item
;;;; $1 is the list item id, $2 is the new status
(pm:defprepared set-list-item-status "select set_list_item_status($1, $2)" :none)

;;;; Clears the items in a list. $1 is the list id.
(pm:defprepared clear-list "select clear_list($1)")

(defun get-list-items ()
  (with-db
    (jsown:to-json (str-alists-to-jsown-json (list-items 1)))))

(defun post-set-list-item-status ()
  (let ((id (parse-integer (h:post-parameter "id") :junk-allowed t))
        (status (parse-integer (h:post-parameter "status") :junk-allowed t)))
    (with-db
      (set-list-item-status id status)
      "")))

(defun post-list-clear ()
  (with-db
    (clear-list 1)
    ""))
