const compareSnapshotCommand = require('cypress-visual-regression/dist/command');
const beforeCompareSnapshotCommand = require('./commands/beforeCompareSnapshotCommand');

// noinspection JSCheckFunctionSignatures
compareSnapshotCommand({
    "errorThreshold": 0.02,
    "capture": "fullPage",
});
beforeCompareSnapshotCommand(
    "div#footer-text"
)