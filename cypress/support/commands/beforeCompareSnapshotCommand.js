// noinspection JSValidateTypes
/**
 * To be called after you setup the command, in order to add a
 * hook that does stuff before the command is triggered
 */
function beforeCompareSnapshotCommand(
    /** Element you want to ignore */
    ignoredElementsQuerySelector,
    /** Main app element (if you want for the page to be loaded before triggering the command) */
    appContentQuerySelector = "body"
) {
    // noinspection JSCheckFunctionSignatures
    Cypress.Commands.overwrite("compareSnapshot", (originalFn, ...args) => {
        // noinspection JSCheckFunctionSignatures
        return cy
            // wait for content to be ready
            .get(appContentQuerySelector)
            // hide ignored elements
            .then($app => {
                return new Cypress.Promise((resolve, reject) => {
                    setTimeout(() => {
                        $app.find(ignoredElementsQuerySelector).css("visibility", "hidden");
                        resolve();
                        // add a very small delay to wait for the elements to be there, but you should
                        // make sure your test already handles this
                    }, 300);
                });
            })
            .then(() => {
                return originalFn(...args);
            });
    });
}

module.exports = beforeCompareSnapshotCommand;