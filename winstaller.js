var electronInstaller = require('electron-winstaller');

resultPromise = electronInstaller.createWindowsInstaller({
  appDirectory: './out/mvp-win32-x64/',
  outputDirectory: './',
  authors: 'Mimix',
  exe: 'mvp.exe',
  setupIcon: './logo.ico'
});

resultPromise.then(() => console.log("It worked!"), (e) => console.log(`No dice: ${e.message}`));
