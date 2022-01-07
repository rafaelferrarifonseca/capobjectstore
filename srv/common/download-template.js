const xlsx = require('xlsx');
module.exports = {
    async handleDownloadTemplate(req) { 
        let oName    = req.data.Name,
            excel    = xlsx.readFileSync(__dirname+'/db/' + oName + '.xlsx'),
            ws       = excel.Sheets[excel.SheetNames[0]],
            range    = xlsx.utils.decode_range(ws["!ref"]).e.r,
            loadFile = xlsx.utils.sheet_to_json(ws, {
                header: "A",
                raw: false,
                range: `A1:ZZ${range+1}`,
                dateNF: "YYYY-MM-DD"
            });
            
        loadFile.shift();

        if (oName === "stock") {
            return {
                stock: {
                    material: loadFile[0].A,
                    plant: loadFile[0].B,
                    stock: loadFile[0].C,
                    unit: loadFile[0].D,
                    
                }
            }
        }
    }
}