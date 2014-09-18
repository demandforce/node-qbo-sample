QuickBooks = require('node-quickbooks')
qboCompany = {}
consumerKey = "qye2eXzQ3VKFhxbgS9MmBeocbpHZ6E"
consumerSecret = "OkGnidNxy3xxKdxdaI2uvI6PSzF2WP4ir5gh1yap"
oauthToken = "qye2enT6Duekw3S4UVxKs9nLJ0WcETb7xcyMXbQqLqcTiw4r"
oauthSecret = "qNtyLwlbAWXNh463x7mwrpiDYmL1AbnqjF5kiig3"
module.exports = (app) ->
  app.get "/invoices/:companyId", (req, res) ->
    companyId = req.params.companyId
    qbo = qboCompany.companyId
    unless qbo
      qbo = new QuickBooks(consumerKey, consumerSecret, oauthToken, oauthSecret, companyId)
    
