(in-package #:groceries)


(defun home ()
  (who:with-html-output-to-string (*standard-output* nil :prologue t)
    (:html
     (:head
      (:meta :charset "utf-8")
      (:title"Uh Oh")
      (:link :href "/style.css" :rel "stylesheet"))
     (:body
      (:h1 "Grocery list")
      (:div
       (:form :id "add"
        (:input :type "text" :name "items" :list "items")
        (:datalist :id "items")
        (:input :type "submit" :value "add")))
      (:script :src "/bundle.js")))))
