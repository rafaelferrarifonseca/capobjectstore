sap.ui.define([
	"./BaseController",
	"../model/entity",
	"../model/columnsExcel",
	"sap/m/MessageToast",
	"sap/m/MessageBox",
	"sap/m/Dialog",
	"sap/ui/layout/VerticalLayout",
	"sap/m/CheckBox",
	"sap/m/RadioButtonGroup",
	"sap/m/RadioButton",
	"sap/m/Button",
	"sap/m/ButtonType",
	"sap/ui/export/library",
	"sap/ui/export/Spreadsheet"
], function (BaseController, Entity, ColumnsExcel, MessageToast, MessageBox, Dialog, VerticalLayout, CheckBox, Button, ButtonType, library, Spreadsheet) {
	"use strict";

	let oFileBase64 = '';

    return BaseController.extend("capobjectstore.uploadstock.controller.Main", {

		/* =========================================================== */
		/* lifecycle methods                                           */
		/* =========================================================== */
		onInit : function () { 
			this.getRouter().getRoute("main").attachPatternMatched(this._onObjectMatched.bind(this), this);
		},

		onWizardStepValidation: function(oEvent) {
			let	aFieldsControl = this.getModel("fieldControl").getData(),
				aFields 	   = ["selectionFile"],
				bValid         = true;

			if (this._wizard) {		
				aFields.forEach(function(sField) {
					if(aFieldsControl[sField] === null || aFieldsControl[sField] === ""){
						aFieldsControl.State[sField].ValueState     = sap.ui.core.ValueState.Error;
						aFieldsControl.State[sField].ValueStateText = this.getResourceBundle().getText("validationFieldRequired");
						bValid = false;
					}else {
						aFieldsControl.State[sField].ValueState     = sap.ui.core.ValueState.None;
						aFieldsControl.State[sField].ValueStateText = "";
					}
				}.bind(this));
							
				this.getModel("fieldControl").refresh();

				if(!bValid) {
					this._wizard.invalidateStep(this.byId("selectFile"));
				} else {
					this._wizard.validateStep(this.byId("selectFile"));
					this._handleUploadComplete();
				}
			}
		},

		onWizardCompletedHandler: function() {
			let aFieldsControl = this.getModel("fieldControl").getData();
			
			
			this._uploadStock(aFieldsControl);
			
		},

		onHandleTypeMissmatch: function (oEvent) {
			let aFileTypes = oEvent.getSource().getFileType()
			
			jQuery.each(aFileTypes, function (key, value) {
				aFileTypes[key] = "*." + value;
			});

			let sSupportedFileTypes = aFileTypes.join(", ");
			MessageToast.show("O Tipo de arquivo *." + oEvent.getParameter("fileType") +
				" não é suportado. Escolha arquivos do seguinte formato: " +
				sSupportedFileTypes);

		},

		onRestartingDataLoading: function() {
			MessageBox.warning(this.getResourceBundle().getText("messageRestarting"), {
                actions: [MessageBox.Action.YES, MessageBox.Action.CANCEL],
				onClose: function(oAction) {
                    if(oAction === MessageBox.Action.YES){
						this._handleNavigationToStep(0);
						this._discardProgress();
					}
				}.bind(this)
			});
		},

		onDownloadTemplate: function() {
			let aFieldsControl = this.getModel("fieldControl").getData();

			
				//_downloadTemplate(oName, sColumns, oNameData, i18nText)
				this._downloadTemplate(
					"stock",
					this.getModel("columnsExcel").getData().columnsStock,
					"stock",
					this.getResourceBundle().getText("mainCheckTextStock")
				);
			
		},
		/* =========================================================== */
		/* internal methods                                            */
		/* =========================================================== */
		_onObjectMatched: function(oEvent) {
			this._wizard 			 = this.byId("CreateWizard");
			this._oNavContainer	 	 = this.byId("wizardNavContainer");
			this._oWizardContentPage = this.byId("wizardContentPage");

			let i18n = {
				//company
				download_material: this.getResourceBundle().getText('download_material'),
				download_plant: this.getResourceBundle().getText('download_plant'),
				download_stock: this.getResourceBundle().getText('download_stock'),
				download_unit: this.getResourceBundle().getText('download_unit')		
			}

			this.getModel("fieldControl").setData(Entity.initSelectionModel());
			this.getModel("fieldControl").refresh(true);
			this.getModel("columnsExcel").setData(ColumnsExcel.initModel(i18n));
			this.getModel("columnsExcel").refresh(true);

			if (this._oNavContainer) {
				this._oWizardReviewPage = sap.ui.xmlfragment(this.getView().getId(),
					"capobjectstore.uploadstock.view.fragments.Review", this);
				this._oNavContainer.addPage(this._oWizardReviewPage);
			}
		},

		_handleUploadComplete: function () {
			let oFileUploader = this.getView().byId("fileUploader");
			let domRef 		  = oFileUploader.getFocusDomRef();
			let file		  = domRef.files[0];

			this._readFile(file);
		},

		_readFile: function (file) {
			this.fileName = file.name;
			this.fileType = file.type;
			let reader    = new FileReader();

			reader.onload = function (e) {
				oFileBase64 = e.currentTarget.result.replace("data:" + file.type + ";base64,", "");
			};
			reader.readAsDataURL(file);
		},

		_uploadStock: function(aFieldsControl) {
			this.setAppBusy(true);

			this.getModel().callFunction("/uploadStock",{
				method: "POST", 
				urlParameters: { File: oFileBase64 },
				success: function(oData){
					this.setAppBusy(false);

					if(oData.results[0].error){
						MessageBox.error(oData.results[0].errorMessage);
						this._wizard.discardProgress(this.byId("selectFile"));
						this._wizard.invalidateStep(this.byId("selectFile"));
					}else {
						let aFields = ["selectionFile"];

						aFields.forEach(function(sField) {
							aFieldsControl.State[sField].Enabled = false;
						});
						this.getModel("fieldControl").refresh();

						this.getModel("logsFile").setData({
							logs: oData.results,
							file: "stock"
						});
						this.getModel("logsFile").refresh(true);

						this._oNavContainer.to(this._oWizardReviewPage);
					}
				}.bind(this),
				error: function(error){
					this.setAppBusy(false);

					MessageBox.error(this.getResourceBundle().getText("errorLoadFile"));

					this._wizard.discardProgress(this.byId("selectFile"));
					this._wizard.validateStep(this.byId("selectFile"));
				}.bind(this)
			});
		},

	
		_backToWizardContent: function () {
			this._oNavContainer.backToPage(this._oWizardContentPage.getId());
		},

		_handleNavigationToStep: function (iStepNumber) {
			let fnAfterNavigate = function () {
				this._wizard.goToStep(this._wizard.getSteps()[iStepNumber]);
				this._oNavContainer.detachAfterNavigate(fnAfterNavigate);
			}.bind(this);

			this._oNavContainer.attachAfterNavigate(fnAfterNavigate);
			this._backToWizardContent();
		},

		_discardProgress: function () {
			let	aFieldsControl = this.getModel("fieldControl").getData(),
				aFields 	   = ["selectionFile", "selectionCheckCompany", "selectionCheckSchedule", 
								  "selectionCheckException", "selectionCheckVendor"];
				
			this._wizard.discardProgress(this.byId("selectFile"));

			let clearContent = function (content) {
				for (let i = 0; i < content.length; i++) {
					if (content[i].setValue) {
						content[i].setValue("");
					}

					if (content[i].getContent) {
						clearContent(content[i].getContent());
					}
				}
			};

			aFieldsControl.selectionFile		   = "";
			aFieldsControl.selectionCheckCompany   = true;
			aFieldsControl.selectionCheckSchedule  = false;
			aFieldsControl.selectionCheckException = false;
			aFieldsControl.selectionCheckVendor	   = false;

			aFields.forEach(function (sField) {
				aFieldsControl.State[sField].ValueState     = sap.ui.core.ValueState.None;
				aFieldsControl.State[sField].ValueStateText = "";
				aFieldsControl.State[sField].Enabled        = true;
			}.bind(this));

			this.getModel("fieldControl").refresh(true);

			this.getModel("logsFile").setData({});
			this.getModel("logsFile").refresh(true);

			clearContent(this._wizard.getSteps());
			this._wizard.invalidateStep(this.byId("selectFile"));
		},

		_downloadTemplate: function(oName, sColumns, oNameData, i18nText) {
			this.getModel().callFunction("/downloadTemplate",{
				method: "POST", 
				urlParameters: { Name:  oName },
				success: function(oData){
					new sap.ui.export.Spreadsheet({
						workbook: { 
							columns: sColumns
						},
						sheetName: oNameData,
						metaSheetName: oNameData,
						dataSource: [oData.results[0][oNameData]],
						fileName: `${i18nText}.xlsx`
					}).build();

				}.bind(this),
				error: function(oError) {
					MessageBox.error(this.getResourceBundle().getText("messageErrorDownload"));
				}.bind(this)
			});
		}
	});
});