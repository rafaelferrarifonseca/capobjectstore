using {
  cuid,
  managed,
  sap,
  temporal,
  Currency,
  User
} from '@sap/cds/common';


namespace capobjectstore.stock;

//---------------------Unit Measure --------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//Entity
entity UnitMeasure {
  key unit            : String(3) not null;
      unitDescription : localized String not null;
}

//Annotation
annotate UnitMeasure with @(
  title              : '{i18n>UnitMeasure}',
  description        : '{i18n>UnitMeasure}',
  UI.TextArrangement : #TextOnly,
  cds.odata.valuelist,
  Common.SemanticKey : [unit],
  UI.Identification  : [{
    $Type : 'UI.DataField',
    Value : unit
  }]
) {
  unit            @(
    title       : '{i18n>Unit}',
    description : '{i18n>Unit}',
    Common      : {
      Text : {
        $value                 : unitDescription,
        ![@UI.TextArrangement] : #TextLast
      }
    }
  );
  unitDescription @(
    title       : '{i18n>unitDescription}',
    description : '{i18n>unitDescription}',
    Common      : {
      FieldControl : #Mandatory,
      TextFor      : unit
    }
  );
};


//---------------------MaterialPlant -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//Entity
@cds.odata.valuelist
entity MaterialPlant : cuid, managed {
  plantCode        : String(4) not null;
  plantDescription : localized String not null;
}

//Annotation
annotate MaterialPlant with @(
    title              : '{i18n>MaterialPlant}',
    description        : plantCode,
    UI.TextArrangement : #TextLast,
    cds.odata.valuelist,
    Common.SemanticKey : [plantCode],
    UI.Identification  : [{
        $Type : 'UI.DataField',
        Value : plantCode

    }]
) {
    ID             @(
        Core.Computed,
        Common.Text : {
            $value                 : plantCode,
            ![@UI.TextArrangement] : #TextFirst
        }
    );
    plantCode           @(
        title       : '{i18n>plantCode}',
        description : '{i18n>plantCode}',
        Common      : {
            FieldControl             : #Mandatory,
            TextFor : ID
        }
    );
    plantDescription    @(
        title       : '{i18n>plantDescription}',
        description : '{i18n>plantDescription}',
        Common      : {
            FieldControl             : #Mandatory
        }
    );
};



//---------------------Material Type -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//Entity
entity MaterialType : cuid, managed {
  matType            : String(4) not null;
  matTypeDescription : String not null;
}
//Annotation
annotate MaterialType with @(
    title              : '{i18n>MaterialType}',
    description        : '{i18n>MaterialType}',
    UI.TextArrangement : #TextOnly,
    cds.odata.valuelist,
    Common.SemanticKey : [matType],
    UI.Identification  : [{
        $Type : 'UI.DataField',
        Value : matType

    }]
) {
    ID             @(
        Core.Computed,
        Common.Text : {
            $value                 : matType,
            ![@UI.TextArrangement] : #TextFirst
        }
    );
    matType           @(
        title       : '{i18n>matType}',
        description : '{i18n>matType}',
        Common      : {
            FieldControl             : #Mandatory,
            TextFor                  : ID
        }
    );
    matTypeDescription    @(
        title       : '{i18n>matTypeDescription}',
        description : '{i18n>matTypeDescription}',
        Common      : {
            FieldControl             : #Mandatory
        }
    );
};


//------------------------Material----------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//Entity
entity Material : cuid, managed {
  materialCode        : String(10) not null;
  materialDescription : localized String not null;
  materialType        : Association to one MaterialType;
  inactive            : Boolean;
  stock               : Composition of many MaterialStock
                          on stock.material = $self;
}

//Annotation
annotate Material with @(
    title              : materialCode,
    description        : materialDescription,
    UI.TextArrangement : #TextLast,
    cds.odata.valuelist,
    Common.SemanticKey : [materialCode],
    UI.Identification  : [{
        $Type : 'UI.DataField',
        Value : materialCode

    }]
) {
    ID             @(
        title       : 'ID',
        description : 'ID',
        Core.Computed,
        Common.Text : {
            $value                 : materialCode,
            ![@UI.TextArrangement] : #TextFirst
        }
    );
    materialCode           @(
        title       : '{i18n>materialCode}',
        description : '{i18n>materialCode}',
        Common      : {
            FieldControl             : #Mandatory,
            TextFor                  : ID
        }
    );
    materialDescription    @(
        title       : '{i18n>materialDescription}',
        description : '{i18n>materialDescription}',
        Common      : {
            FieldControl             : #Mandatory,
        }
    );
    materialType @(
        title       : '{i18n>materialType}',
        description : '{i18n>materialType}',
        Common      : {
            Text      : {
                $value                 : materialType.matType,
                ![@UI.TextArrangement] : #TextOnly
            },
            ValueList : {
                CollectionPath  : 'MaterialType',
                SearchSupported : true,
                Parameters      : [
                {

                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'materialType_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'matType'
                },                
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'matTypeDescription'
                }
                ]
            }
        }
    );
    inactive       @(
        title       : '{i18n>inactive}',
        description : '{i18n>inactive}',
    );
    stock    @(
        title       : '{i18n>stock}',
        description : '{i18n>stock}'
    );
};



//------------------- Material Stock -------------------//
//------------------------------------------------------//
//------------------------------------------------------//
//Entity
entity MaterialStock : cuid {
  material : Association to Material;
  plant    : Association to MaterialPlant;
  stock    : Integer;
  unit     : Association to UnitMeasure;
}
//Annotation
annotate MaterialStock with {
    ID          @Core.Computed;
    material   @(
        Common.Text                     : {
            $value                 : material.materialCode,
            ![@UI.TextArrangement] : #TextLast
        },
        Common.ValueListWithFixedValues : false,
        title                           : '{i18n>material}',
        Common.ValueList                : {
            CollectionPath : 'Material',
            SearchSupported: true,
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'material_ID',
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'unit'
            },
            ]
        }
    );
    plant @(
        Common.Text                     : {
            $value                 : plant.plantDescription,
            ![@UI.TextArrangement] : #TextLast
        },
        title                           : '{i18n>plant}',
        Common.ValueListWithFixedValues : false,
        Common.ValueList                : {
            CollectionPath : 'MaterialPlant',
            SearchSupported: true,
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'plant_ID',
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'plantDescription'
            },
            ]
        }
    );
    stock @(
        title       : '{i18n>stock}',
        description : '{i18n>stock}',  
    );
    unit @(
        title                           : '{i18n>unit}',
        Common.ValueListWithFixedValues : false,
        Common.ValueList                : {
            CollectionPath : 'Unit',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'unit_unit',
                ValueListProperty : 'unit'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'unitDescription'
            },
            ]
        }

    )
};


