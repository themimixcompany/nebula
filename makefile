.PHONY: all build install_engine install_viewer create_linux_package save_image

DIR := $(shell basename "$(shell pwd)")
BASE_NAME = mvp
IMAGE_NAME = $(BASE_NAME)-${TAG}
DOCKERFILE = ./Dockerfile

all: build save_image

build: install_engine install_viewer create_linux_package
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME) .

install_engine:
	rm -rf app/engine
	mkdir -p app/engine
	cp -v ${ENGINE_RELEASES}/* app/engine

install_viewer:
	rm -rf app/viewer
	git clone ${VIEWER_SOURCES} app/viewer

create_linux_package:
	#electron-forge package --platform=linux
	ssh mimix-ubuntu "cd /home/vagrant/mvp-electron; electron-forge package --platform=linux"

save_image:
	mkdir -p ${RELEASES}/docker/$(BASE_NAME)/${TAG}
	docker save -o ${RELEASES}/docker/$(BASE_NAME)/${TAG}/$(IMAGE_NAME).tar $(IMAGE_NAME)
	gzip ${RELEASES}/docker/$(BASE_NAME)/${TAG}/$(IMAGE_NAME).tar

run:
	docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(IMAGE_NAME)

clean:
	rm -rf app/engine
	rm -rf app/viewer
	rm -rf out

create_windows_package:
	electron-forge package --platform=win32

create_macos_package:
	electron-forge package --platform=darwin
