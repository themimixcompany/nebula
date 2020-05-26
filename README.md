nebula
======


<a name="toc">Table of contents</a>
-----------------------------------

- [Overview](#overview)
- [Viewer](#viewer)
  + [Linux](#viewerlinux)
  + [Windows](#viewerwindows)
  + [macOS](#viewermacos)
  + [Testing](#viewertesting)
  + [Executables](#viewerexecutables)
- [Engine](#engine)
- [Deployment](#deployment)
  + [Linux](#deploymentlinux)
  + [Windows](#deploymentwindows)
  + [macOS](#deploymentmacos)
- [Notes](#notes)


<a name="overview">Overview</a>
-------------------------------

Nebula is a system of software deployment that simplifies the packaging and distribution of cross-platform applications built with Node.js, HTML, and WebSockets. Nebula is implemented with two components: the viewer, which provides the graphical interface, and the engine, which provides the backend services. For information on how to configure and develop the browser-based elements of a Nebula app such as its navigation and UI, see [https://mimix.io/nebula-tech/](https://mimix.io/nebula-tech/).

The viewer is implemented using [Electron](https://electronjs.org/) with [Node.js](https://nodejs.org/en/) for the runtime, and [Chromium](https://www.chromium.org/Home) for the rendering. The code that serves the HTML is done using [AngularJS](https://angularjs.org/). [Electron Packager](https://www.npmjs.com/package/electron-packager) and [Electron Builder](https://github.com/electron-userland/electron-builder/) are used to build the final application executables. The engine is implemented using Common Lisp, with [SBCL](http://sbcl.org) as the primary implementation.

Installers and binary packages for Linux, Windows, and macOS systems are available under [Releases](https://github.com/themimixcompany/nebula/releases).


<a name="viewer">Viewer</a>
---------------------------

This section describes the procedures for building the viewer on Linux, Windows, and macOS systems. In order to run the viewer, key dependencies such as Node.js must first be installed.


### <a name="viewerlinux">Linux</a>

On Ubuntu systems, install Node.js and friends with:

```bash
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
```

On Fedora systems, install Node.js and friends with:

```bash
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
```

On Arch Linux, install Node.js and friends with:

```bash
sudo pacman -S nodejs npm
```


### <a name="viewerwindows">Windows</a>

On Windows systems, download and run the installer from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).


### <a name="viewermacos">macOS</a>

On macOS systems, download and run the installer from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).


### <a name="viewertesting">Testing</a>

The minimum required versions for Node.js and npm are `8.10.0` and `3.5.2`, respectively. If they are met, switch to the nebula directory with:

```bash
cd nebula
```

Then, run the following command to install the required dependencise:

```bash
npm install
```

When all the dependencies have been installed, check to see that the application can indeed run with:

```bash
npm start
```


### <a name="viewerexecutables">Executables</a>

To create the bundled applications for Linux, Windows, and macOS systems, respectively, run:

```bash
electron-packager . --platform=linux --out=out --icon=assets/icons/icon.png --prune=true
electron-builder --linux --prepackaged out/nebula-linux-x64
```

```bash
electron-packager . --platform=win32 --out=out --icon=assets/icons/icon.ico --prune=true
electron-builder --windows --prepackaged out/nebula-win32-x64
```

```bash
electron-packager . --platform=darwin --out=out --icon=assets/icons/icon.icns --prune=true
electron-builder --macos --prepackaged out/nebula-darwin-x64
```

The commands will create Nebula executables under the respective `out/` subdirectories, which contain the application and its local resources and dependencies.


<a name="engine">Engine</a>
---------------------------

The documentation for building the engine are available at [https://github.com/themimixcompany/streams#building](https://github.com/themimixcompany/streams#building).


<a name="deployment">Deployment</a>
-----------------------------------


### <a name="deploymentlinux">Linux</a>

To be able to run the Linux and macOS binaries, a set of required runtime dependencies must first be installed. On Ubuntu, you may install them with:

```bash
sudo apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1
```

To run the app, navigate to the `out/nebula-linux-x64` subdirectory mentioned in the last section, then run the `Mimix Nebula` binary:

```bash
cd out/nebula-linux-x64
./Mimix\ Nebula
```


### <a name="deploymentwindows">Windows</a>

To run the app, navigate to the `out/nebula-win32-x64` subdirectory mentioned in the last section, then run the `Mimix Nebula` binary either by double-clicking `Mimix Nebula.exe` or by navigating in the command line with:

```bash
cd out/nebula-win32-x64
Mimix Nebula
```


### <a name="deploymentmacos">macOS</a>

To run the app, navigate to the `out/nebula-darwin-x64` subdirectory mentioned in the last section, then run the `Mimix Nebula` binary either by double-clicking `Mimix Nebula.app` or by navigating in the command line with:

```bash
cd out/nebula-darwin-x64
open Mimix\ Nebula.app
```


<a name="notes">Notes</a>
-------------------------

Testing the [Single Page Application](https://en.wikipedia.org/wiki/Single-page_application) during development is done with [local-web-server](https://github.com/lwsjs/local-web-server/). To use it, install lws as a global dependency and run it with an index.html file:

```bash
npm i -g local-web-server
cd app
ws -s index.html
```
