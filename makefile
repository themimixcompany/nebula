.PHONY: all engine clean
DIR := $(shell basename "$(shell pwd)")

engine:
	mkdir -p engine
	sbcl --eval '(ql:quickload :engine)' --eval "(sb-ext:save-lisp-and-die #P\"engine/engine\" :toplevel #'engine:main :executable t)"

clean:
	rm -rf engine