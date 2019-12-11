var installer = require('electron-installer-flatpak');

var options = {
  src: 'out/mvp-linux-x64/',
  dest: './',
  arch: 'x64'
};

console.log('Creating package (this may take a while)');

installer(options, function (err) {
  if (err) {
    console.error(err, err.stack);
    process.exit(1);
  }

  console.log('Successfully created package at ' + options.dest);
});