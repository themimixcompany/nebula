.PHONY: all clean docker_build install_engine install_viewer save_image linux_package windows_package macos_package

DIR := $(shell basename "$(shell pwd)")
BASE_NAME = mvp
IMAGE_NAME = $(BASE_NAME)-${TAG}
DOCKERFILE = ./Dockerfile

all: docker_build save_image

build:
	electron-build

docker_build: install_engine install_viewer
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME) .

clean:
	rm -rf node_modules
	rm -rf out

install:
	npm install

start:
	npm start

install_engine:
	rm -rf app/engine
	mkdir -p app/engine
	cp -v ${ENGINE_RELEASES}/engine_unix_X64 app/engine

install_viewer:
	rm -rf app/viewer
	git clone ${VIEWER_SOURCES} app/viewer

docker_save_image:
	mkdir -p ${RELEASES}/docker/$(BASE_NAME)/${TAG}
	docker save -o ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar $(IMAGE_NAME)
	gzip -f ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar

docker_run:
	docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(IMAGE_NAME)

packages: clean install linux_package windows_package macos_package

linux_package:
	electron-forge package --platform=linux

windows_package:
	electron-forge package --platform=win32

macos_package:
	electron-forge package --platform=darwin

linux_installer:
	electron-builder --linux --prepackaged out/mvp-linux-x64

windows_installer:
	electron-builder --windows --prepackaged out/mvp-win32-x64

macos_installer:
	electron-builder --macos --prepackaged out/mvp-darwin-x64
