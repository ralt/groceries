(asdf:defsystem #:groceries
  :description "Easy way to handle my grocery lists"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:hunchentoot :cl-who :postmodern :alexandria :cl-ppcre :jsown)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "db")
                         (:file "render")
                         (:file "routes/home")
                         (:file "routes/item")
                         (:file "groceries")))))
