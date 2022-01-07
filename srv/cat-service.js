const cds = require('@sap/cds');
const xsenv = require("@sap/xsenv");
const { getBundle } = require('./common/i18n');

const { handleUploadStock } = require('./commom/upload-stock');
const { handleDownloadTemplate } = require('./commom/download-template');

const AWS = require('aws-sdk')

class CatalogService extends cds.ApplicationService {
    init() {

        this.on('getBlob',  async (req) => {
            const vcap_services = JSON.parse(process.env.VCAP_SERVICES)
            const AWS = require('aws-sdk')
            const credentials = new AWS.Credentials(
                vcap_services.objectstore[0].credentials.access_key_id,
                vcap_services.objectstore[0].credentials.secret_access_key)
            AWS.config.update({
                region: vcap_services.objectstore[0].credentials.region,
                credentials: credentials
            })

            const s3 = new AWS.S3({
                apiVersion: '2006-03-01'
            });

        	if (!req.data.ID) {
                return next()
            }
    
            return {
                value: _getObjectStream(req.data.ID)
            }
        });
            
        this.on('setBlob',  async (req) => {
            const vcap_services = JSON.parse(process.env.VCAP_SERVICES)
            
            const credentials = new AWS.Credentials(
                vcap_services.objectstore[0].credentials.access_key_id,
                vcap_services.objectstore[0].credentials.secret_access_key)
            AWS.config.update({
                region: vcap_services.objectstore[0].credentials.region,
                credentials: credentials
            })
            const s3 = new AWS.S3({
                apiVersion: '2006-03-01'
            });

            const params = {
                Bucket: vcap_services.objectstore[0].credentials.bucket,
                Key: req.data.ID,
                Body: req.data.content,
                ContentType: "image/png"
            };
            s3.upload(params, function (err, data) {
                console.log(err, data)
            })
        });

        this.on('uploadStock', async (req, res) => {
            try {
                const service = cds.services.uploadstock;
                return await handleUploadStock(req, service);
            } catch (e) {
                console.error('ERRO: ' + e)
                throw(e);
            }
        });

        this.on('downloadTemplate', async (req, res) => {
            try {
                return await handleDownloadTemplate(req);
            } catch (e) {
                console.error('ERRO: ' + e)
                throw(e);
            }
        });

        /* Get object stream from S3 */
        function _getObjectStream(objectKey) {
            const params = {
                Bucket: vcap_services.objectstore[0].credentials.bucket,
                Key: objectKey
            };
            return s3.getObject(params).createReadStream()
        }

            return super.init();
        }


}


module.exports = { CatalogService };
