.PHONY: watch

SOURCE_FILES=$(shell find js/ -name '*.js')
OUT_FILE=static/bundle.js

all:
	./node_modules/.bin/browserify js/main.js -t babelify | ./node_modules/.bin/uglifyjs2 -mc > $(OUT_FILE)

watch:
	./node_modules/.bin/watchify -d js/main.js -t babelify -o $(OUT_FILE)
