const cds = require('@sap/cds');
const xsenv = require("@sap/xsenv");
const { getBundle } = require('./common/i18n');


class CatalogService extends cds.ApplicationService {
    init() {

        this.on('getBlob', 'NotasFiscais', async (req) => {
            
        });
            
        this.on('setBlob', 'NotasFiscais', async (req) => {

        });

        return super.init();
    }
}


module.exports = { CatalogService };
