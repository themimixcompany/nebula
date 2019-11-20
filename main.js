const {app, BrowserWindow} = require('electron');
const path = require('path');
const child = require('child_process').execFile;
const fs = require('fs');

var dirPrefix = "";

if (fs.existsSync("./resources/app")) {
    dirPrefix="./resources/app/";
} else {
    dirPrefix="./";
}

const enginePath = `${dirPrefix}engine/engine_linux`;
const engineArgs = [];

const webServerPath = `${dirPrefix}node_modules/local-web-server/bin/cli.js`;
const webServerArgs = ["-d", `${dirPrefix}app`, "-s", "index.html"];

function loadServers () {
    child(enginePath, engineArgs, (err, data) => {
        console.log(err);
        console.log(data.toString());
    });

    child(webServerPath, webServerArgs, (err, data) => {
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
    loadServers();
    createWindow();
}

app.on('ready', runApp);

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
    if (mainWindow === null) createWindow();
});
