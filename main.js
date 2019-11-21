const {app, BrowserWindow} = require('electron');
const path = require('path');
const child = require('child_process').execFile;
const fs = require('fs');
const express = require('express');

const appexpress = express();
const port = process.env.PORT || 8000;

appexpress.use(express.static('app'));

appexpress.listen(port, () => {
  console.log('listening on %d', port);
});

var dirPrefix = "";

if (fs.existsSync("./resources/app")) {
    dirPrefix="./resources/app/";
} else {
    dirPrefix="./";
}

function loadEngine () {
    var enginePath = `${dirPrefix}engine/engine_linux`;
    var engineArgs = [];

    // Note: check for existing running engines, first
    child(enginePath, engineArgs, (err, data) => {
        console.log(err);
        console.log(data.toString());
    });
}

let mainWindow;

function createWindow () {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
    });

    mainWindow.loadURL("http://localhost:8000");
    // mainWindow.webContents.openDevTools()

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
}

function runApp () {
    loadEngine();
    createWindow();
}

app.on('ready', runApp);

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
    if (mainWindow === null) createWindow();
});
