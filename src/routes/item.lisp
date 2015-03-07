(in-package #:groceries)


;;;; Gets the list of all the items
(pm:defprepared items "select items()" :rows)

;;;; Adds an item in a list, returns the item id
;;;; $1 is the item name, $2 is the list id
(pm:defprepared add-item "select add_item($1, $2)" :single)
