sap.ui.define([
	"sap/ui/test/opaQunit",
	"./pages/ListReport"
], function (opaTest) {
	"use strict";

	var Journey = {
		run: function() {
			QUnit.module("Ticketum Journey");

			opaTest("Should see the List Report", function (Given, When, Then) {
				// Arrangements
				Given.iStartMyApp();

				// Actions
				// When.onTheListReport.iLookAtTheScreen();

				// Assertions
				Then.onTheListReport.iShouldSeeTheTable();

				// Cleanup
				Then.iTeardownMyApp();
			});
		}
	};

	Journey.run();
});