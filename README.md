Nebula
======


Overview
--------

This section briefly describes the main components of Nebula. This section presents a very high level overview of the existing version of the suite.

The engine is implemented using Common Lisp, with [SBCL](http://sbcl.org) as the primary implementation. Currently, it contains the modules websocket and build. The websocket module is responsible for opening a two-way commmunication stream between itself and the outside world. In our case it creates a socket between the engine and the Electron application. The build module is used for producing standalone executables that the Electron component will spawn.

The viewer is implemented using framework [Electron](https://electronjs.org/) with [Node.js](https://nodejs.org/en/) for the runtime and [Chromium](https://www.chromium.org/Home) for the rendering. The code that serves the HTML is done using [AngularJS](https://angularjs.org/). [Electron Forge](https://www.npmjs.com/package/electron-forge) and [Electron Packager](https://www.npmjs.com/package/electron-packager) were used to build the final application executables.



Building
--------


### Engine

### Overview

This section contains the instrutions for building the Engine on Linux and Windows systems. The minimum required software are [SBCL](http://sbcl.org) and [Git](https://git-scm.com).


#### Linux

On Ubuntu systems install SBCL with:

```bash
sudo apt-get install -y sbcl git curl
```

The minimum required version must be 1.4.5. To check if you meet this requirement, run:

```bash
sbcl --version
```

Next, [Quicklisp](https://quicklisp.org) and the other dependencies must be installed:

```bash
mkdir -p ~/common-lisp
git clone https://github.com/fare/asdf ~/common-lisp/asdf
git clone https://github.com/ebzzry/mof ~/common-lisp/mof
curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'
```

Next, clone the sources of the Engine:

```bash
cd ~/common-lisp
git clone https://github.com/themimixcompany/engine
```

Next, build the Engine executable:

```bash
cd engine
sbcl --eval "(ql:quickload :engine)" --eval "(engine:build)"
```

This creates an Engine executable in the subdirectory `engine/` where the command was run.


### Windows

On Windows 7 and up, download and install [SBCL](http://sbcl.org/platform-table.html). The latest version of SBCL for Windows at the time of writing is `1.4.14`.

To verify that you have succesfully install SBCL, run the following command in the Command Prompt:

```dos
sbcl --version
```

Next, [Quicklisp](https://quicklisp.org) and the other dependencies must be installed.

First, download Quicklisp from [https://beta.quicklisp.org/quicklisp.lisp](https://beta.quicklisp.org/quicklisp.lisp). Then, move `quicklisp.lisp` to `%HOMEPATH%`. In the Command Prompt go to `%HOMEDIR%`:

```dos
cd %HOMEDIR%
```

Then load `quicklisp.lisp` with the installation functions:

```dos
sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'
```

Next, download and install [Git](https://git-scm.com/download/win). to verify that you have succesfully installed Git, run the following command in the Command Prompt:

```dos
git --version
```

Now that we have Git installed, we’ll download the dependencies:

```dos
cd %HOMEDIR%
md common-lisp
cd common-lisp
git clone https://github.com/fare/asdf
git clone https://github.com/ebzzry/mof
```

Before we continue, we need to install OpenSSL for Windows. Head over to the [Win32/Win64 OpenSSL site](http://slproweb.com/products/Win32OpenSSL.html) then download and install the file [Win64 OpenSSL v1.1.1d Light](http://slproweb.com/download/Win64OpenSSL_Light-1_1_1d.exe). Restart your machine after installing it.

Next we go back to the command prompt, to fetch the engine:

```dos
cd %HOMEDIR%\common-lisp
git clone https://github.com/themimixcompany/engine
```

Next, build the Engine executable:

```dos
cd engine
sbcl --eval "(ql:quickload :engine)" --eval "(engine:build)"
```

This creates an Engine executable in the subdirectory `engine/` where the command was run.



### Viewer

This section describes the procedures for building the Viewer on Linux and windows systems.

#### Linux

To build the viewer on Linux systems, you must first install Node.js. On Ubuntu, run:

```bash
sudo apt-get update
sudo apt-get install -y nodejs npm
```

Additionally you must install some Wine dependencies:

```bash
sudo dpkg --add-architecture i386
sudo apt-get install -y wine mono-complete wine-development wine32-development wine64-development
```

The minimum required versions for nodejs and npm are `8.10.0` and `3.5.2`, respectively. To check if you meet these requirements, run:

```bash
node --version
npm --version
```

Inside the nebula directory, run the following command to install the required dependencise:

```bash
npm install
```

When all the dependencies have been installed, check to see that the application
can indeed run with:

```bash
npm start
```

To create a bundled application, run:

```bash
npm run package
```

This command creates an `out/nebula-linux-x64` subdirectory that contains the application and its local resources and dependencies.

To build for Windows, run:

```bash
electron-forge make --platform=win32
electron-forge package --platform=win32
```


#### Windows

TODO


Deployment
----------


### Linux

To be able to run the Linux binaries, a set of required runtime dependencies must first be installed. On Ubuntu, you may install them with:

```bash
sudo apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1
```

To run the app itself, navigate to the `out/nebula-linux-x64` subdirectory mentioned in the last section, then run the `nebula` binary:

```bash
cd out/nebula-linux-x64
./nebula
```


### Windows

TODO


Notes
-----


### package.json

To build an Electron app that uses Electron Forge, it must conform to the methods that Electron Forge uses. The value of the key `"scripts"` must be invocations to `electron-forge` and not the vanilla `electron`:

```json
"scripts": {
  "start": "electron-forge start",
  "package": "electron-forge package",
  "make": "electron-forge make",
  "publish": "electron-forge publish",
  "lint": "echo \"No linting configured\""
}
```

Another important part is the value for the `config.forge` key. It must have values for the object `packagerConfig`—which should conform to the [electron-packager API](https://github.com/electron/electron-packager/blob/master/docs/api.md), and for the object `makers` which is a list of maker specifications for [electron-forge](https://www.electronforge.io/config/makers).

The values that the Nebula uses look similar to the following:

```json
"config": {
  "forge": {
    "packagerConfig": {
      "name": "nebula",
      "dir": ".",
      "overwrite": "true"
    },
    "makers": [
      {
        "name": "@electron-forge/maker-zip",
        "platforms": [
          "darwin",
          "linux",
          "windows"
        ]
      },
      {
        "name": "@electron-forge/maker-deb",
        "config": {
          "maintainer": "David Bethune",
          "homepage": "https://mimix.io"
        }
      },
      {
        "name": "@electron-forge/maker-squirrel",
        "config": {
          "name": "nebula"
        }
      },
    ]
  }
}
```

The `makers` parameter is used when running the command `npm run make`, which builts installer executables for each platform specified, while the `packagerConfig` parameters specifies parameter for building a self-contained directory with all the runtime dependencies.


### main.js

Testing the [Single Page Application](https://en.wikipedia.org/wiki/Single-page_application) during development is done with [local-web-server](https://github.com/lwsjs/local-web-server/). To use it, install lws as a global dependency and run it with an index.html file:

```bash
npm i -g local-web-server
cd app
ws -s index.html
```

However, due to the fact that controlling the spawning of child processes via `package.json` is not amenable to Electron Forge, creating child processes are done instead inside `main.js` using [Express](https://expressjs.com/). The way it is used with the NEBULA is as such:

```javascript
const express = require('express');
const appexpress = express();
const port = process.env.PORT || 8000;

appexpress.use(express.static("app"));
appexpress.listen(port, () => {
  console.log('listening on %d', port);
});
```

This expression correctly serves the file `./app/index.html` as a proper application.
