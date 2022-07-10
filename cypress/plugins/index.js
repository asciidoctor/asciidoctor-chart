const compareSnapshotsPlugin = require('cypress-visual-regression/dist/plugin');

module.exports = (on, config) => {
  compareSnapshotsPlugin(on, config);

  require('cypress-mochawesome-reporter/plugin')(on);

  // force color profile
  on('before:browser:launch', (browser = {}, launchOptions) => {
    if (browser.family === 'chromium' && browser.name !== 'electron') {
      launchOptions.args.push('--force-color-profile=srgb');
    }
  });

  return {
    browsers: config.browsers.filter(
      (b) => b.family === 'chromium' && b.name !== 'electron'
    ),
  };
};
