.PHONY: all engine clean dockerbuild forcedockerbuild dockerrun run package
DIR := $(shell basename "$(shell pwd)")
NAME = "mvp-angularjs"
DOCKERFILE = "../../dockerfiles/mvp-angularjs/Dockerfile"

engine:
	mkdir -p engine
	sbcl --eval "(ql:quickload :engine)" --eval "(engine:build)"

clean:
	rm -rf engine
	rm -rf out

dockerbuild:
	docker build -f $(DOCKERFILE) -t $(NAME) .

forcedockerbuild:
	docker build --no-cache -f $(DOCKERFILE) -t $(NAME) .

dockerrun:
	docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(NAME)

run:
	npm start

package:
	npm run package

start:
	npm start
