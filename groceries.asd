(asdf:defsystem #:groceries
  :description "Easy way to handle my grocery lists"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:hunchentoot :cl-who :postmodern :alexandria :cl-ppcre)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "db")
                         (:file "routes/home")
                         (:file "groceries")))))
