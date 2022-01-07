sap.ui.define([
	"sap/ui/model/json/JSONModel"
], function(JSONModel) {
	"use strict";
    return {	
		initModel: function(i18n) {
			return {
			    columnsStock: [
                    {
                        label: i18n.download_material,
					    property: "material",
					    type: sap.ui.export.EdmType.String,
                        width: "8rem"
                    },
                    {
                        label: i18n.download_plant,
					    property: "plant",
					    type: sap.ui.export.EdmType.String,
                        width: "10rem"
                    },
                    {
                        label: i18n.download_CCM,
					    property: "stock",
					    type: sap.ui.export.EdmType.Integer,
                        width: "8rem"
                    },
                    {
                        label: i18n.download_certificate,
					    property: "unit",
					    type: sap.ui.export.EdmType.String,
                        width: "10rem"
                    }
                ],
			};
		}
	};
});