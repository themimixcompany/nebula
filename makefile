.PHONY: all clean build install_engine install_viewer save_image linux_package windows_package macos_package

DIR := $(shell basename "$(shell pwd)")
BASE_NAME = nebula
IMAGE_NAME = $(BASE_NAME)-${TAG}
DOCKERFILE = ./Dockerfile

all: build save_image

build: install_engine install_viewer
	docker build -f $(DOCKERFILE) -t $(IMAGE_NAME) .

clean:
	rm -rf node_modules

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
	electron-packager . --platform=linux --out=out --icon=assets/icons/icon.png --overwrite

windows_package:
	electron-packager . --platform=win32 --out=out --icon=assets/icons/icon.ico --overwrite

macos_package:
	electron-packager . --platform=darwin --out=out --icon=assets/icons/icon.icns --overwrite

linux_installers:
	electron-builder --linux --prepackaged out/$(BASE_NAME)-linux-x64

windows_installers:
	electron-builder --windows --prepackaged out/$(BASE_NAME)-win32-x64

macos_installers:
	electron-builder --macos --prepackaged out/$(BASE_NAME)-darwin-x64
	mkdir -p ${RELEASES}/macos/$(BASE_NAME)/${TAG}/installers
	mv -f out/$(BASE_NAME)-${TAG}.dmg ${RELEASES}/macos/$(BASE_NAME)/${TAG}/installers

macos_sync:
	rsync -avz --delete --delete-excluded --exclude .git --exclude node_modules --exclude out "${PWD}" "${MACOS}"
