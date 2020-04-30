SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.RECIPEPREFIX +=

.PHONY: all clean build install_streams install_world save linux_package windows_package macos_package linux_installers windows_installers macos_installers appdmg

DIR := $(shell basename "$(shell pwd)")
BASE_NAME = nebula
IMAGE_NAME = $(BASE_NAME)-${TAG}
PRODUCT_NAME = Mimix Nebula
DOCKERFILE = ./Dockerfile

STREAMS_DIR = ./app/streams
WORLD_DIR = ./app/world

all: build save

build: install_streams install_world
  docker build -f $(DOCKERFILE) -t $(IMAGE_NAME) .

clean:
  rm -rf node_modules

install:
  npm install

start:
  npm start

install_streams:
  rm -rf $(STREAMS_DIR)
  mkdir -p $(STREAMS_DIR)
  cp -v ${ENGINE_RELEASES}/streams_unix_X64 $(STREAMS_DIR)

install_world:
  rm -rf $(WORLD_DIR)
  git clone ${VIEWER_SOURCES} $(WORLD_DIR)

save:
  mkdir -p ${RELEASES}/docker/$(BASE_NAME)/${TAG}
  docker save -o ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar $(IMAGE_NAME)
  gzip -f ${RELEASES}/docker/$(BASE_NAME)/${TAG}/docker-$(IMAGE_NAME).tar

run:
  docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $(IMAGE_NAME)

linux_package:
  electron-packager . --platform=linux --out=out --icon=assets/icons/icon.png --overwrite

windows_package:
  electron-packager . --platform=win32 --out=out --icon=assets/icons/icon.ico --overwrite

macos_package:
  electron-packager . --platform=darwin --out=out --icon=assets/icons/icon.icns --overwrite

linux_installers:
  electron-builder --linux --prepackaged "out/$(PRODUCT_NAME)-linux-x64"

windows_installers:
  electron-builder --windows --prepackaged "out/$(PRODUCT_NAME)-win32-x64"

macos_installers: appdmg
  cp -r "${RELEASES}/macos/$(BASE_NAME)/${TAG}/app/$(PRODUCT_NAME).app" "$(PRODUCT_NAME).app"
  appdmg nebula-dmg.json "out/$(PRODUCT_NAME)-${TAG}.dmg"
  rm -rf "$(PRODUCT_NAME).app"
  mv -f "out/$(PRODUCT_NAME)-${TAG}.dmg" ${RELEASES}/macos/$(BASE_NAME)/${TAG}/installers

appdmg:
  npm install -g appdmg
