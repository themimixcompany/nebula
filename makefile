.PHONY: all clean engine
DIR := $(shell basename "$(shell pwd)")

engine:
	mkdir -p engine
	sbcl --eval '(ql:quickload :engine)' --eval "(engine:build)"

clean:
	rm -rf engine