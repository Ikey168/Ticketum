sap.ui.define([
	"sap/ui/test/Opa5",
	"./arrangements/Startup",
	"./Journey"
], function (Opa5, Startup) {
	"use strict";

	Opa5.extendConfig({
		arrangements: new Startup(),
		viewNamespace: "ticketum.fiori.view.",
		autoWait: true
	});
});