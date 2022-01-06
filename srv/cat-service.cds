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
  
}