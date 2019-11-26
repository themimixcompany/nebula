.PHONY: all engine clean dockerbuild forcedockerbuild dockerrun start

DIR := $(shell basename "$(shell pwd)")
NAME = "mvp-angularjs"
DOCKERFILE = "./Dockerfile"

engine:
	mkdir -p src/engine
	sbcl --eval "(ql:quickload :engine)" --eval "(engine:build)"

clean:
	rm -rf src/engine
	rm -rf out

dockerbuild:
	docker build -f $(DOCKERFILE) -t $(NAME) .

forcedockerbuild:
	docker build --no-cache -f $(DOCKERFILE) -t $(NAME) .

dockerrun:
	docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(NAME)

start:
	npm start

linuxpackage:
	electron-forge package --platform=linux

windowspackage:
	electron-forge package --platform=win32

macospackage:
	electron-forge package --platform=darwin
