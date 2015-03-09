APP_NAME=groceries
LISP_FILES=$(shell find . -name '*.lisp')
ASDF_TREE ?= ~/quicklisp/
DIST_FOLDER ?= dist
APP_OUT=$(DIST_FOLDER)/groceries
QL_LOCAL=$(PWD)/.quicklocal/quicklisp
QUICKLISP_SCRIPT=http://beta.quicklisp.org/quicklisp.lisp
LOCAL_OPTS=--noinform --noprint --disable-debugger --no-sysinit --no-userinit
QL_OPTS=--load $(QL_LOCAL)/setup.lisp
LISP ?= sbcl
SOURCES := $(wildcard src/*.lisp) $(wildcard *.asd)
BUILDAPP = ./bin/buildapp
SOURCE_FILES=$(shell find js/ -name '*.js')
OUT_FILE=static/bundle.js

.PHONY: js js-watch

all: $(APP_OUT)

bin:
	@mkdir bin

clean:
	@-yes | rm -rf $(QL_LOCAL)
	@-rm -f $(APP_OUT) deps install-deps

$(QL_LOCAL)/setup.lisp:
	@curl -O $(QUICKLISP_SCRIPT)
	@sbcl $(LOCAL_OPTS) \
		--load quicklisp.lisp \
		--eval '(quicklisp-quickstart:install :path "$(QL_LOCAL)")' \
		--eval '(quit)'

deps:
	@sbcl $(LOCAL_OPTS) $(QL_OPTS) \
	     --eval '(push "$(PWD)/" asdf:*central-registry*)' \
	     --eval '(ql:quickload :groceries)' \
	     --eval '(quit)'
	@touch $@

install-deps: $(QL_LOCAL)/setup.lisp deps
	@touch $@

bin/buildapp: bin $(QL_LOCAL)/setup.lisp
	@cd $(shell sbcl $(LOCAL_OPTS) $(QL_OPTS) \
				--eval '(ql:quickload :buildapp :silent t)' \
				--eval '(format t "~A~%" (asdf:system-source-directory :buildapp))' \
				--eval '(quit)') && \
	$(MAKE) DESTDIR=$(PWD) install

$(APP_OUT): $(SOURCES) bin/buildapp $(QL_LOCAL)/setup.lisp install-deps
	@mkdir -p $(DIST_FOLDER)
	@$(BUILDAPP) --logfile /tmp/build.log \
			--sbcl sbcl \
			--asdf-path . \
			--asdf-tree $(QL_LOCAL)/local-projects \
			--asdf-tree $(QL_LOCAL)/dists \
			--asdf-path . \
			--load-system $(APP_NAME) \
			--entry $(APP_NAME):main \
			--compress-core \
			--output $(APP_OUT)

js:
	./node_modules/.bin/browserify js/main.js -t babelify | ./node_modules/.bin/uglifyjs2 -mc > $(OUT_FILE)

js-watch:
	./node_modules/.bin/watchify -d js/main.js -t babelify -o $(OUT_FILE)
