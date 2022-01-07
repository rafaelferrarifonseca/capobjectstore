using CatalogService from './cat-service';

//---------------------MaterialPlant -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//List Page
annotate CatalogService.MaterialPlant with @(
	UI: {
        LineItem: [
			{   
                $Type: 'UI.DataField', 
                Value: plantCode,
                ![@UI.Importance] : #High
            },
            {   
                $Type : 'UI.DataField', 
                Value : plantDescription,
                ![@UI.Importance] : #High
            }
		],
        PresentationVariant : {
            $Type     : 'UI.PresentationVariantType',
            SortOrder : [{Property : plantCode}]
        },
        SelectionFields: [ 
            plantCode,
            plantDescription
        ],
	},
//Object Page
	UI: {
        HeaderInfo: {          
            Title : { 
                $Type : 'UI.DataField',
                Value: ID
            },
            TypeName: '{i18n>plant_singular}',
            TypeNamePlural: '{i18n>plant_plural}', 
            Description: { 
                $Type: 'UI.DataField', 
                Value: plantDescription 
            }, 
        },
		HeaderFacets            : [
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.FieldGroup#Admin',
                ![@UI.Importance] : #Medium
            }
        ],
        FieldGroup #GeneralData: {
			Data: [
                {
                    $Type : 'UI.DataField',
                    Value: plantCode
                },
				{
                    $Type : 'UI.DataField',
                    Value: plantDescription
                }
			]                        
        },
        FieldGroup #Admin: {
            Data : [
                {
                    $Type : 'UI.DataField',
                    Value : createdBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : createdAt
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedAt
                }
            ]
        },
        // Page Facets
		Facets: [
            {    
                $Type: 'UI.ReferenceFacet', 
                Label: '{i18n>GeneralData}', 
                Target: '@UI.FieldGroup#GeneralData'
            }
        ]    
    }
);


//--------------------- MaterialType -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//List Page
annotate CatalogService.MaterialType with @(
	UI: {
        LineItem: [
			{   
                $Type: 'UI.DataField', 
                Value: matType,
                ![@UI.Importance] : #High
            },
            {   
                $Type : 'UI.DataField', 
                Value : matTypeDescription,
                ![@UI.Importance] : #High
            }
		],
        PresentationVariant : {
            $Type     : 'UI.PresentationVariantType',
            SortOrder : [{Property : matType}]
        },
        SelectionFields: [ 
            matType,
            matTypeDescription
        ],
	},
//Object Page
	UI: {
        HeaderInfo: {          
            Title : { 
                $Type : 'UI.DataField',
                Value: ID
            },
            TypeName: '{i18n>matType_singular}',
            TypeNamePlural: '{i18n>matType_plural}', 
            Description: { 
                Value: matTypeDescription 
            }, 
        },
		 HeaderFacets            : [
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.FieldGroup#Admin',
                ![@UI.Importance] : #Medium
            }
        ],
        FieldGroup #GeneralData: {
			Data: [
                {
                    $Type : 'UI.DataField',
                    Value: matType
                },
				{
                    $Type : 'UI.DataField',
                    Value: matTypeDescription
                },

			]                        
        },
        FieldGroup #Admin: {
            Data : [
                {
                    $Type : 'UI.DataField',
                    Value : createdBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : createdAt
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedAt
                }
            ]
        },
        // Page Facets
		Facets: [
            {    
                $Type: 'UI.ReferenceFacet', 
                Label: '{i18n>GeneralData}', 
                Target: '@UI.FieldGroup#GeneralData'
            }
        ]      
    }
);

//---------------------- Material ----------------------//
//------------------------------------------------------//
//------------------------------------------------------//
annotate CatalogService.Material with @(
//List Page
	UI: {
        LineItem: [
			{   
                $Type: 'UI.DataField', 
                Value: materialCode,
                ![@UI.Importance] : #High
            },
            {   
                $Type : 'UI.DataField', 
                Value : materialDescription,
                ![@UI.Importance] : #High
            },
            {   
                $Type: 'UI.DataField', 
                Value: materialType_ID,
                ![@UI.Importance] : #High
            },
			{   
                $Type: 'UI.DataField', 
                Value: inactive,
                ![@UI.Importance] : #High
            }
		],
        PresentationVariant : {
            $Type     : 'UI.PresentationVariantType',
            SortOrder : [{Property : materialCode}]
        },
        SelectionFields: [ 
            materialCode,
            materialDescription,
            materialType_ID,
            inactive
        ],
	},
//Object Page
	UI: {
        HeaderInfo: {          
            Title : { 
                $Type : 'UI.DataField',
                Value: ID
            },
            TypeName: '{i18n>material_singular}',
            TypeNamePlural: '{i18n>material_plural}', 
            Description: { 
                Value: materialDescription 
            }
        },
		 HeaderFacets            : [
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.FieldGroup#Admin',
                ![@UI.Importance] : #Medium
            }
        ],
        FieldGroup #GeneralData: {
			Data: [
                {
                    $Type : 'UI.DataField',
                    Value: materialCode
                },
				{
                    $Type : 'UI.DataField',
                    Value: materialDescription
                },

			]                        
        },
        FieldGroup #Details: {
			Data: [
				{
                    $Type : 'UI.DataField',
                    Value: materialType_ID
                },
                {
                    $Type: 'UI.DataField', 
                    Value: inactive
                }
			]            
        },
        FieldGroup #Admin: {
            Data : [
                {
                    $Type : 'UI.DataField',
                    Value : createdBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedBy
                },
                {
                    $Type : 'UI.DataField',
                    Value : createdAt
                },
                {
                    $Type : 'UI.DataField',
                    Value : modifiedAt
                }
            ]
        },
        Facets: [
         // Page Facets
            {    
                $Type: 'UI.ReferenceFacet', 
                Label: '{i18n>GeneralData}', 
                Target: '@UI.FieldGroup#GeneralData'
            },
            {    
                $Type: 'UI.ReferenceFacet', 
                Label: '{i18n>Details}', 
                Target: '@UI.FieldGroup#Details'
            },              
            {   
                $Type: 'UI.ReferenceFacet', 
                Label: '{i18n>stock}',  
                Target : 'stock/@UI.LineItem'
          
            },
		],      
    }
);


//------------------- Material Stock -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
annotate CatalogService.MaterialStock with @(
//List Page
	UI: {
    	TextArrangement     : #TextLast,
        LineItem: [ 
            /*          
			{
                $Type             : 'UI.DataField',
                Value             : material_ID,
                ![@UI.Importance] : #High
            },
            */
			{
                $Type             : 'UI.DataField',
                Value             : plant_ID,
                ![@UI.Importance] : #High
            },            
            {   
                $Type                   : 'UI.DataField',
                Value                   : plant.plantDescription,
                ![@Common.FieldControl] : #ReadOnly,
                ![@UI.Importance]       : #High
            },          
 			{   
                $Type                   : 'UI.DataField',
                Value                   : stock,
                //![@Common.FieldControl] : #ReadOnly,
                ![@UI.Importance]       : #High,
            },
            {   
                $Type                   : 'UI.DataField',
                Value                   : unit_unit,
                ![@Common.FieldControl] : #ReadOnly,
                ![@UI.Importance]       : #High,
            }
		],
        PresentationVariant : {SortOrder : [{
            $Type      : 'Common.SortOrderType',
            Property   : material_ID,
            Descending : false
        }]}
    },
//Object Header
   UI: { 
        HeaderInfo: {         
            Title: {
                $Type : 'UI.DataField',
                Value : '{i18n>stock_singular}'
            },    
            TypeName       : '{i18n>stock_singular}',
            TypeNamePlural : '{i18n>stock_singular}',
            Description    : {
                Value : '{i18n>stock_singular}'
            }
        },

        FieldGroup #Details : {
            Data : [
                {
                    $Type : 'UI.DataField',
                    Value : plant_ID,
                },
                {
                    $Type : 'UI.DataField',
                    Value : stock,
                },
                {
                    $Type                   : 'UI.DataField',
                    Value                   : unit_unit,
                    ![@Common.FieldControl] : #ReadOnly,
                    ![@UI.Importance]       : #High
                }
            ]
        },
    // Page Facets
        Facets : [
            {
                $Type  : 'UI.CollectionFacet',
                ID     : 'MaterialStockDetails',
                Label  : '{i18n>details}',
                Facets : [
                    {
                        $Type  : 'UI.ReferenceFacet',
                        Label  : '{i18n>details}',
                        Target : '@UI.FieldGroup#Details'
                    }
                ]
            }
        ]
    }  
); 