describe('visual regression tests', () => {

    it('should display the Chart.js charts correctly', () => {
        cy.visit('./examples/chartjs.html').wait(3000).compareSnapshot('chart.js')
    });

    it('should display the C3.js charts correctly', () => {
        cy.visit('./examples/c3js.html').wait(3000).compareSnapshot('c3.js')
    });

    it('should display the Chartist.js charts correctly', () => {
        cy.visit('./examples/chartist.html').wait(3000).compareSnapshot('chartist.js')
    });

})

