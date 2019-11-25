MVP
===


Overview
--------

This section briefly describes the main components of the MVP. This section presents a very high level overview of the existing version of the suite.


### Engine

The engine is implemented using Common Lisp, with [SBCL](http://sbcl.org) as the primary implementation. Currently, it contains the modules websocket and build. The websocket module is responsible for opening a two-way commmunication stream between itself and the outside world. In our case it creates a socket between the engine and the Electron application. The build module is used for producing standalone executables that the Electron component will spawn.


### Viewer

The viewer is implemented using framework [Electron](https://electronjs.org/) with [Node.js](https://nodejs.org/en/) for the runtime and [Chromium](https://www.chromium.org/Home) for the rendering. The code that serves the HTML is done using [AngularJS](https://angularjs.org/). [Electron Forge](https://www.npmjs.com/package/electron-forge) and [Electron Packager](https://www.npmjs.com/package/electron-packager) were used to build the final application executables.



Building
--------


### Engine

On Ubuntu, the Lisp compiler SBCL must first be installed with:

```bash
sudo apt-get install -y sbcl
```

The minimum required version must be 1.4.5. To check if you meet this requirement, run:

```bash
sbcl --version
```

Next, [Quicklisp](https://quicklisp.org) and the other dependencies must be installed:

```bash
mkdir -p ~/bin ~/common-lisp
git clone https://github.com/fare/asdf ~/common-lisp/asdf
git clone https://github.com/ebzzry/mof ~/common-lisp/mof
curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'
```

Next, clone the sources of the Engine:

```bash
cd ~/common-lisp
git clone https://github.com/themimixcompany/mvp
```

Next, build the Engine executable:

```bash
sbcl --eval "(ql:quickload :engine)" --eval "(engine:build)"
```

This creates an Engine executable in the subdirectory `engine/` where the command was run.


### Viewer

To build the viewer, you must first install Node.js. On Ubuntu, run:

```bash
sudo apt-get install -y nodejs npm
```

The minimum required versions for nodejs and npm are `8.10.0` and `3.5.2`, respectively. To check if you meet these requirements, run:

```bash
node --version
npm --version
```

Inside the mvp directory, run the following command to install the required dependencise:

```bash
npm install
```

When all the dependencies have been installed, check to see that the application
can indeed run, install electron-forge globally, then run the start script:

```bash
npm i -g electron-forge
npm start
```

To create a bundled application, run:

```bash
npm run package
```

This command creates an `out/mvp-linux-x64` subdirectory that contains the application and its local resources and dependencies.


Deployment
----------


### Linux

To be able to run the Linux binaries, a set of required runtime dependencies must first be installed. On Ubuntu, you may install them with:

```bash
sudo apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1
```

To run the app itself, navigate to the `out/mvp-linux-x64` subdirectory mentioned in the last section, then run the `mvp` binary:

```bash
cd out/mvp-linux-x64
./mvp
```


### Windows

TODO


Structure
---------

This section briefly describes the directory structure of the MVP that comes with this README.


### Engine

The subdirectory `engine` contains a platform-specific self-contained executable of the Lisp engine. The sources for the Engine can be found on [GitHub](https://github.com/themimixcompany/engine).


### Viewer

The subdirectory `app` contains a snapshot of the AngularJS sources. The most recent version of the AngularJS source can be found on [Tresorit](https://tresor.it/p#0008104xvt3rxrmktaj72kf9/Mimix%20Dev/Source/angularjs).


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

The values that the MVP uses look similar to the following:

```json
"config": {
  "forge": {
    "packagerConfig": {
      "name": "mvp",
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
          "name": "mvp"
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

However, due to the fact that controlling the spawning of child processes via `package.json` is not amenable to Electron Forge, creating child processes are done instead inside `main.js` using [Express](https://expressjs.com/). The way it is used with the MVP is as such:

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
