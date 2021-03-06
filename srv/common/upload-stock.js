const { insertIntoCompanies, 
        getCompaniesForCNPJ, 
        stockCompany,
        getEmptyCCMPrefec, 
        insertIntoCompaniesPrefectures 
      }              = require("./db/db-upload-stock");
const { getBundle }  = require('./i18n');
const xlsx           = require('xlsx');


async function handleUploadStock(req, service) {
    const tx = service.tx();

    try {
        let oBundle   = getBundle(req.user.locale);
        let excelXlsx = xlsx.read(req.data.File);
        let ws        = excelXlsx.Sheets[excelXlsx.SheetNames[0]];
        let range     = xlsx.utils.decode_range(ws["!ref"]).e.r;
        
        let loadFile  = xlsx.utils.sheet_to_json(ws, {
            header: "A",
            raw: false,
            range: `A1:ZZ${range+1}`,
            dateNF: "YYYY-MM-DD"
        });        

        //Retira/Obtem o header do arquivo
        let loadFileHeader = loadFile.shift(),
            headerExpected = [`${oBundle.getText('download_CNPJ')}`       ,`${oBundle.getText('download_name')}`,
                              `${oBundle.getText('download_CCM')}`        ,`${oBundle.getText('download_certificate')}`,
                              `${oBundle.getText('download_description')}`,`${oBundle.getText('download_cityName')}`,
                              `${oBundle.getText('download_UF')}`
                             ],
            headerName     = ["A","B","C","D","E","F","G"];
        
        for(let i=0; i < headerName.length; i++){
            if(loadFileHeader[headerName[i]] != headerExpected[i]){
                return {
                    log: {
                        material: null,
                        plant: null,
                        message: "",
                    },
                    error: true,
                    errorMessage: oBundle.getText("ErrorExcel")
                }
            }
        }

        //Converte o Objeto em um array de CNPJs
        let newStock  = [],
            logsStock = [];

        for (let i = 0; i < loadFile.length; i++) {
            newCompanies[i] = {
                material: loadFile[i].A,
                plant: loadFile[i].B,
                stock: loadFile[i].C,
                unit: loadFile[i].D,
            }
        }
/* inserir c??digo para validar campos e buscar dados validando 
        //Pega todas prefeituras com CCM false
        let aPrefectures = await getEmptyCCMPrefec(service);

        //Empresas inseridas durante a execu????o
        let arrayInsertedCompanies = [];

        for (let newCompany of newCompanies) {

            
            let validationCNPJ = ("00000" + newCompany.CNPJ).slice(-14);

            //Remove os zeros a esquerda do numero do vendor
            let vendorNumber = newCompany.CNPJ
            vendorNumber = Number(vendorNumber).toString();
            newCompany.CNPJ = vendorNumber

            if(cnpj.isValid(validationCNPJ)){
                //Busca o CNPJ dentro das empresas ja cadastradas
                let companyInSystem = await getCompaniesForCNPJ(service, newCompany.CNPJ);

                //Se o cnpj esta dentro da array de CNPJs entao realizar o update
                if (companyInSystem) {
                    //Se p CNPJ j?? existe no sistema    
                    logsCompanies.push({
                        log: {
                            CNPJ: newCompany.CNPJ,
                            name: newCompany.name,
                            message: oBundle.getText("ErrorCompanyRegistered")
                        },
                        error: false,
                        errorMessage: ''
                    });
                } else {
                    let concatCity,
                        companyInserted;
                    
                    //Cria novo cadastro de empresa dentro do sistema
                    //Concatena o nome da cidade atual do exel sendo percorrido
                    concatCity = newCompany.city + "/" + newCompany.state;

                    if (concatCity === 'S??O PAULO/SP') {
                        //Buscar id da prefeitura e inserir no homeprefecture_id
                        for (let index = 0; index < aPrefectures.length; index++) {
                            if (aPrefectures[index].prefectureName === 'S??o Paulo/SP') {
                                newCompany.homeprefecture_id = aPrefectures[index].ID;
                                break;
                            }
                        }
                    }

                    //Faz o Insert no sistema
                    try {
                        companyInserted = await insertIntoCompanies(tx, service, newCompany);

                        if (companyInserted) {
                            arrayInsertedCompanies.push(companyInserted.CNPJ);
                        } else {
                            logsCompanies.push({
                                log: {
                                    CNPJ: newCompany.CNPJ,
                                    name: newCompany.name,
                                    message: oBundle.getText("ErrorFailedRegisterCompany"),
                                },
                                error: false,
                                errorMessage: ""
                            });
                        }
                    } catch (e) {
                        logsCompanies.push({
                            log: {
                                CNPJ: newCompany.CNPJ,
                                name: newCompany.name,
                                message: oBundle.getText("ErrorFailedRegisterCompany"),
                            },
                            error: false,
                            errorMessage: ""
                        });
                        throw (e)
                    }

                    let aCompaniesPrefectures = [];

                    //Faz o Insert do CompaniesPrefectures
                    for(let prefecture of aPrefectures) {
                        aCompaniesPrefectures.push({
                            "companies_ID": companyInserted.ID,
                            "prefectures_ID": prefecture.ID,
                        });
                    }

                    try {
                        await insertIntoCompaniesPrefectures(tx, service, aCompaniesPrefectures);
                    } catch (e) {
                        throw (e)
                    } 
                    await tx.commit();
                }
            }else {
                logsCompanies.push({
                    log: {
                        CNPJ: newCompany.CNPJ,
                        name: newCompany.name,
                        message: oBundle.getText("ErrorInvalidCNPJ"),
                    },
                    error: false,
                    errorMessage: ""
                });
            }

            
        }
*/
        return logsCompanies;
    } catch (e) {
        throw (e)
    }
}

module.exports.handleUploadStock = handleUploadStock;
