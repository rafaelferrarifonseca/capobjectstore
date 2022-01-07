using capobjectstore.stock as capobjectstore from '../db/data-model';

service CatalogService { // @( requires:'authenticated-user') {
    // Serviços para criação de APP FIORI DE CADASTROS
    entity UnitMeasure   as projection on capobjectstore.UnitMeasure;
    @odata.draft.enabled : true
    entity MaterialPlant as projection on capobjectstore.MaterialPlant;
    
    @odata.draft.enabled : true
    entity MaterialType  as projection on capobjectstore.MaterialType;
    
    @odata.draft.enabled : true
    entity Material      as projection on capobjectstore.Material {
        * , stock: redirected to MaterialStock    
    };
    @readonly 
    entity MaterialStock as projection on capobjectstore.MaterialStock {
        *, plant : redirected to MaterialPlant
    };

    //Serviços para manipulação de dados
    entity MaterialPlantCRUD as projection on capobjectstore.MaterialPlant;
    entity MaterialStockCRUD  as projection on capobjectstore.MaterialStock {
        *, plant: redirected to MaterialPlantCRUD
    }
   
   //Serviços para objectstore
    action setBlob(blobPDF :  LargeBinary, ID: UUID);
    
    function getBlob(ID: UUID) returns LargeString;


    //Serviço para carga de excel
    //UPLOAD Stock
    type logsStock {
                log: {
                   MaterialCode: String;
                   plant: String;
                   message: String;
                };
                error: Boolean;
                errorMessage: String;      
        }
    type downloadsTemplates {
                stock: {
                    material: String;
                    plant: String;
                    stock: Integer;
                    unit: String;
                };
        }

    action uploadStock(File: LargeString ) returns array of logsStock;
  
    //Download dos templates de carga
    action downloadTemplate(Name: String) returns array of downloadsTemplates;
}