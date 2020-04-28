Nebula
======


<a name="toc">Table of Contents</a>
-----------------------------------

- [Overview](#overview)
- [Viewer](#viewer)
  + [Linux](#viewerlinux)
  + [Windows](#viewerwindows)
  + [macOS](#viewermacos)
- [Engine](#engine)
  + [Linux](#enginelinux)
  + [Windows](#enginewindows)
  + [macOS](#enginemacos)
- [Deployment](#deployment)
  + [Linux](#deploymentlinux)
  + [Windows](#deploymentwindows)
  + [macOS](#deploymentmacos)
- [Notes](#notes)
  + [main.js](#mainjs)


<a name="overview">Overview</a>
-------------------------------

Nebula is system of software deployment simplifies the packaging and
distribution of cross-platform applications built with NodeJS, HTML, and
WebSockets. Nebula is implemented with two components: the viewer, which
provides the graphical interface, and the engine, which provides the backend
services.

The viewer is implemented using framework [Electron](https://electronjs.org/)
with [Node.js](https://nodejs.org/en/) for the runtime and
[Chromium](https://www.chromium.org/Home) for the rendering. The code that
serves the HTML is done using
[AngularJS](https://angularjs.org/). [Electron Packager](https://www.npmjs.com/package/electron-packager)
and [Electron Builder](https://github.com/electron-userland/electron-builder/)
are used to build the final application executables.

The engine is implemented using Common Lisp, with [SBCL](http://sbcl.org) as the
primary implementation.


<a name="viewer">Viewer</a>
---------------------------

This section describes the procedures for building the viewer on Linux, Windows,
and macOS systems.


### <a name="viewerdependies">Dependencies</a>

In order to run the viewer, key dependencies such as Node.js must first be
installed.


#### <a name="viewerlinux">Linux</a>

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


#### <a name="viewerwindows">Windows</a>

On Windows systems, download and run the installer from
[https://nodejs.org/en/download/](https://nodejs.org/en/download/).


#### <a name="viewermacos">macOS</a>

On macOS systems, download and run the installer from
[https://nodejs.org/en/download/](https://nodejs.org/en/download/).


### <a name="viewertesting">Testing</a>

The minimum required versions for Node.js and npm are `8.10.0` and `3.5.2`,
respectively. If they are met, switch to the nebula directory with:

```bash
cd nebula
```

Then, run the following command to install the required dependencise:

```bash
npm install
```

When all the dependencies have been installed, check to see that the application
can indeed run with:

```bash
npm start
```


### <a name="viewerexecutables">Executables</a>

To create bundled applications for Linux, Windows, and macOS systems,
respectively, run:

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

The commands will create nebula executables under the respecive `out/`
subdirectories, which contain the application and its local resources and
dependencies.


<a name="engine">Engine</a>
---------------------------

This section contains the instructions for building the engine on Linux, macoS, and
Windows systems. The minimum required software are [SBCL](http://sbcl.org) and
[Git](https://git-scm.com).


### <a name="enginelinux">Linux</a>

On Ubuntu systems, install the SBCL and friends with:

```bash
sudo apt-get install -y sbcl git curl
```

On Fedora systems, install SBCL and friends with:

```bash
sudo yum install -y sbcl git curl
```

On Arch Linux, install SBCL and friends with:

```bash
sudo pacman -S sbcl git curl
```

Next, [Quicklisp](https://quicklisp.org) and the other dependencies must be installed:

```bash
mkdir -p ~/common-lisp
git clone https://gitlab.common-lisp.net/asdf/asdf/ ~/common-lisp/asdf
git clone https://github.com/ebzzry/marie ~/common-lisp/marie
curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'
```

Next, clone the sources of the engine:

```bash
cd ~/common-lisp
git clone https://github.com/themimixcompany/streams
```

Next, build the engine executable:

```bash
cd engine
sbcl --eval "(ql:quickload :streams)" --eval "(streams:build)"
```

This creates the engine executable in the current directory.


### <a name="enginewindows">Windows</a>

On Windows 7 and up, download and install
[SBCL](http://sbcl.org/platform-table.html). The latest version of SBCL for
Windows at the time of writing is `2.0.0`.

To verify that you have succesfully install SBCL, run the following command in
the Command Prompt:

```dos
sbcl --version
```

Next, [Quicklisp](https://quicklisp.org) and the other dependencies must be installed.

First, download Quicklisp from
[https://beta.quicklisp.org/quicklisp.lisp](https://beta.quicklisp.org/quicklisp.lisp). Then,
move `quicklisp.lisp` to `%HOMEPATH%`. In the Command Prompt go to `%HOMEDIR%`:

```dos
cd %HOMEDIR%
```

Then load `quicklisp.lisp` with the installation functions:

```dos
sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'
```

Next, download and install [Git](https://git-scm.com/download/win). to verify
that you have succesfully installed Git, run the following command in the
Command Prompt:

```dos
git --version
```

Now that we have Git installed, we’ll download the dependencies:

```dos
cd %HOMEDIR%
md common-lisp
cd common-lisp
git clone https://gitlab.common-lisp.net/asdf/asdf/
git clone https://github.com/ebzzry/marie
```

Before we continue, we need to install OpenSSL for Windows. Head over to the
[Win32/Win64 OpenSSL site](http://slproweb.com/products/Win32OpenSSL.html) then
download and install the file
[Win64 OpenSSL v1.1.1d Light](http://slproweb.com/download/Win64OpenSSL_Light-1_1_1d.exe). Restart
your machine after installing it.

Next we go back to the command prompt, to fetch the engine:

```dos
cd %HOMEDIR%\common-lisp
git clone https://github.com/themimixcompany/streams
```

Next, build the engine executable:

```dos
cd engine
sbcl --eval "(ql:quickload :streams)" --eval "(streams:build)"
```

This creates an engine executable in the current directory.


<a name="deployment">Deployment</a>
-----------------------------------


### <a name="deploymentlinux">Linux</a>

To be able to run the Linux and macOS binaries, a set of required runtime dependencies
must first be installed. On Ubuntu, you may install them with:

```bash
sudo apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1
```

To run the app, navigate to the `out/nebula-linux-x64` subdirectory
mentioned in the last section, then run the `nebula` binary:

```bash
cd out/nebula-linux-x64
./nebula
```


### <a name="deploymentwindows">Windows</a>

To run the app, navigate to the `out/nebula-win32-x64` subdirectory mentioned in
the last section, then run the `nebula` binary either by double-clicking
`nebula.exe` or by navigating in the command line with:

```bash
cd out/nebula-win32-x64
nebula
```


### <a name="deploymentmacos">macOS</a>

To run the app, navigate to the `out/nebula-darwin-x64` subdirectory
mentioned in the last section, then run the `nebula` binary:

```bash
cd out/nebula-darwin-x64
./nebula
```


<a name="notes">Notes</a>
-------------------------


### <a name="mainjs">main.js</a>

Testing the
[Single Page Application](https://en.wikipedia.org/wiki/Single-page_application)
during development is done with
[local-web-server](https://github.com/lwsjs/local-web-server/). To use it,
install lws as a global dependency and run it with an index.html file:

```bash
npm i -g local-web-server
cd app
ws -s index.html
```
