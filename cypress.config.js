const { defineConfig } = require('cypress')

module.exports = defineConfig({
  screenshotsFolder: 'cypress/snapshots/actual',
  trashAssetsBeforeRuns: true,
  video: false,
  env: {
    failSilently: false,
  },
  e2e: {
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
