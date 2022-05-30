const { defineConfig } = require('cypress')

module.exports = defineConfig({
  screenshotsFolder: 'cypress/snapshots/actual',
  trashAssetsBeforeRuns: true,
  video: false,
  env: {
    failSilently: false,
  },
  e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
    setupNodeEvents(on, config) {
      return require('./cypress/plugins/index.js')(on, config)
    },
  },
  reporter: "cypress-multi-reporters",
  reporterOptions: {
    reporterEnabled: 'mocha-junit-reporter, cypress-mochawesome-reporter',
    mochaJunitReporterReporterOptions: {
      mochaFile: "./cypress/results/junit.xml",
      toConsole: false
    },
    cypressMochawesomeReporterReporterOptions: {
      reportDir: "cypress/reports",
      charts: true,
      embeddedScreenshots: true,
      inlineAssets: true
    },
  }
})
