QuickBooks = require('node-quickbooks')
qboCompany = {}
consumerKey = "qye2eXzQ3VKFhxbgS9MmBeocbpHZ6E"
consumerSecret = "OkGnidNxy3xxKdxdaI2uvI6PSzF2WP4ir5gh1yap"
oauthToken = "qye2enT6Duekw3S4UVxKs9nLJ0WcETb7xcyMXbQqLqcTiw4r"
oauthSecret = "qNtyLwlbAWXNh463x7mwrpiDYmL1AbnqjF5kiig3"

findQbo = (companyId) ->
  qbo = qboCompany.companyId
  unless qbo
    qbo = new QuickBooks(consumerKey, consumerSecret, oauthToken, oauthSecret, companyId)
    qboCompany[companyId] = qbo
  return qbo
  
module.exports = (app) ->
  app.get "/company/:companyId/invoices", (req, res) ->
    companyId = req.params.companyId
    qbo = findQbo(companyId)
    qbo.findInvoices (err, result) ->
      res.json(result)
      
  app.get "/company/:companyId", (req, res) ->
    companyId = req.params.companyId
    qbo = findQbo(companyId)
    qbo.getCompanyInfo companyId, (err, result) ->
      res.json(result)

  app.get "/company/:companyId/customers", (req, res) ->
    companyId = req.params.companyId
    qbo = findQbo(companyId)
    qbo.findCustomers (err, result) ->
      res.json(result)

  app.get "/company/:companyId/customer/:customerId", (req, res) ->
    companyId = req.params.companyId
    customerId = req.params.customerId
    qbo = findQbo(companyId)
    qbo.findCustomers {Id: customerId}, (err, result) ->
      res.json(result)
