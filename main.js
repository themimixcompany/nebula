const {app, BrowserWindow} = require('electron');

const path = require('path');
const child = require('child_process').execFile;
const fs = require('fs');
const express = require('express');
const appexpress = express();
const port = process.env.PORT || 8000;

var dirPrefix = "";

if (fs.existsSync(path.resolve(__dirname, "resources/app"))) {
  dirPrefix = path.resolve(__dirname, "resources/app");
} else {
  dirPrefix = path.resolve(__dirname);
}

function loadExpress () {
  appexpress.use(express.static(`${dirPrefix}/app`));
  appexpress.listen(port, () => {
    console.log('listening on %d', port);
  });
}

function getPlatformSuffix () {
  if (process.platform === 'linux'){
    return "_linux";
  } else if (process.platform === 'win32'){
    return "_windows.exe";
  } else if (process.platform === 'darwin') {
    return "_darwin";
  } else {
    console.log(`This platform ${process.platform} is unsupported.`);
  }
}

function loadEngine () {
  var platformSuffix = getPlatformSuffix();
  var enginePath = `${dirPrefix}/engine/engine${platformSuffix}`;
  var engineArgs = [];

  child(enginePath, engineArgs, (err, data) => {
    console.log(err);
    console.log(data.toString());
  });
}

let mainWindow;

function createWindow () {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  mainWindow.loadURL("http://localhost:8000");
  // mainWindow.webContents.openDevTools()

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function runApp () {
  loadExpress();
  loadEngine();
  createWindow();
}

function main () {
  app.on('ready', runApp);

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
  });

  app.on('activate', () => {
    if (mainWindow === null) createWindow();
  });
}

main();
