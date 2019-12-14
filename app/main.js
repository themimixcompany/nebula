const {app, BrowserWindow} = require('electron');
const path = require('path');
const child = require('child_process').execFile;
const fs = require('fs');
const express = require('express');
const appexpress = express();
const host = process.env.HOST || '127.0.0.1';
const vport = process.env.VPORT || 8000;
const wport = process.env.WPORT || 9797;
const portscanner = require('portscanner');
var dirPrefix = null;

function setDirPrefix () {
  if (process.platform === 'linux' || process.platform === 'win32'){
    if (fs.existsSync(path.resolve(__dirname, 'resources/app'))) {
      dirPrefix = path.resolve(__dirname, 'resources/app');
    } else {
      dirPrefix = path.resolve(__dirname);
    }
  } else if (process.platform === 'darwin') {
    if (fs.existsSync(path.resolve(__dirname, '../Resources/app'))) {
      dirPrefix = path.resolve(__dirname, '../Resources/app');
    } else {
      dirPrefix = path.resolve(__dirname);
    }
  } else {
    console.log(`The platform ${process.platform} is unsupported.`);
  }
}

function loadExpress () {
  appexpress.use(express.static(`${dirPrefix}/viewer`));
  appexpress.listen(vport, () => {
    console.log('Express listening on %s:%d', host, vport);
  });
}

function getPlatformSuffix () {
  if (process.platform === 'linux'){
    return '_unix_X64';
  } else if (process.platform === 'win32'){
    return '_windows_X64.exe';
  } else if (process.platform === 'darwin') {
    return '_macos_X64';
  } else {
    console.log(`The platform ${process.platform} is unsupported.`);
  }
}

function loadEngine () {
  var platformSuffix = getPlatformSuffix();
  var enginePath = `${dirPrefix}/engine/engine${platformSuffix}`;
  var engineArgs = [];
  var child_status = null;

  portscanner.checkPortStatus(wport, host, (error, status) => {
    if (status == 'closed') {
      child_status = child(enginePath, engineArgs);
      child_status.stdout.on('data', (data) => {
        console.log(data);
      });
    } else {
      console.log(`The WebSocket port ${wport} is not available`);
    }
  });
}

let mainWindow;

function createWindow () {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  mainWindow.loadURL(`http://${host}:${vport}`);
  // mainWindow.webContents.openDevTools()

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function runApp () {
  setDirPrefix();
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
