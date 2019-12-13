.PHONY: all clean build install_engine install_viewer save_image linux_package windows_package macos_package

DIR := $(shell basename "$(shell pwd)")
BASE_NAME = nebula
IMAGE_NAME = $(BASE_NAME)-${TAG}
DOCKERFILE = ./Dockerfile

all: docker_build save_image

build: install_engine install_viewer
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

save_image:
	mkdir -p ${RELEASES}/docker/$(BASE_NAME)/${TAG}
	docker save -o ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar $(IMAGE_NAME)
	gzip -f ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar

docker_run:
	docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(IMAGE_NAME)

packages: linux_package windows_package macos_package

linux_package:
	electron-packager . --platform=linux --out=out --icon=assets/icons/icon.png --prune=true

windows_package:
	electron-packager . --platform=win32 --out=out --icon=assets/icons/icon.ico --prune=true

macos_package:
	electron-packager . --platform=darwin --out=out --icon=assets/icons/icon.icns --prune=true

linux_installer:
	electron-builder --linux --prepackaged out/nebula-linux-x64

windows_installer:
	electron-builder --windows --prepackaged out/nebula-win32-x64

macos_installer:
	electron-builder --macos --prepackaged out/nebula-darwin-x64
