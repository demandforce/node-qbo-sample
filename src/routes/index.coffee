QuickBooks = require('node-quickbooks')
moment     = require('moment')
qboCompany = {}
consumerKey = "qye2eXzQ3VKFhxbgS9MmBeocbpHZ6E"
consumerSecret = "OkGnidNxy3xxKdxdaI2uvI6PSzF2WP4ir5gh1yap"
oauthToken = "qye2enT6Duekw3S4UVxKs9nLJ0WcETb7xcyMXbQqLqcTiw4r"
oauthSecret = "qNtyLwlbAWXNh463x7mwrpiDYmL1AbnqjF5kiig3"

_findQbo = (companyId) ->
  qbo = qboCompany.companyId
  unless qbo
    qbo = new QuickBooks(consumerKey, consumerSecret, oauthToken, oauthSecret, companyId)
    qboCompany[companyId] = qbo
  return qbo

_formatCustomer = (rawCustomer) ->
  customer = 
    id: rawCustomer.Id
    firstName: rawCustomer.GivenName
    lastName: rawCustomer.FamilyName
    phone: rawCustomer.PrimaryPhone?.FreeFormNumber
    email: rawCustomer.PrimaryEmailAddr?.Address

_formatInvoice = (rawInvoice, customers) ->
  customer = customers.filter (customer) -> customer.id == rawInvoice.CustomerRef.value
  invoice =
    created: moment(rawInvoice.MetaData.CreateTime).format('MMMM Do YYYY, h:mm:ss a')
    updated: moment(rawInvoice.MetaData.LastUpdatedTime).format('MMMM Do YYYY, h:mm:ss a')
    total: rawInvoice.TotalAmt
    balance: rawInvoice.Balance
    dueDate: moment(rawInvoice.DueDate).format('MMMM Do YYYY')
    customer: customer[0]

module.exports = (app) ->
  app.get "/company/:companyId/invoices", (req, res) ->
    companyId = req.params.companyId
    qbo = _findQbo(companyId)
    qbo.findCustomers (err, result) ->
      raw = result.QueryResponse.Customer
      customers = raw.map (customer) -> _formatCustomer(customer)
      qbo.findInvoices {desc: 'MetaData.CreateTime', limit: 10}, (err, result) ->
        raw = result.QueryResponse.Invoice
        invoices = raw.map (invoice) -> _formatInvoice(invoice, customers)
        res.json(invoices)

  app.get "/company/:companyId", (req, res) ->
    companyId = req.params.companyId
    qbo = _findQbo(companyId)
    qbo.getCompanyInfo companyId, (err, result) ->
      res.json(result)

  app.get "/company/:companyId/customers", (req, res) ->
    companyId = req.params.companyId
    qbo = _findQbo(companyId)
    qbo.findCustomers (err, result) ->
      raw = result.QueryResponse.Customer
      customers = raw.map (customer) -> _formatCustomer(customer)
      res.json(customers)


  app.get "/company/:companyId/customer/:customerId", (req, res) ->
    companyId = req.params.companyId
    customerId = req.params.customerId
    qbo = _findQbo(companyId)
    qbo.findCustomers {Id: customerId}, (err, result) ->
      res.json(_formatCustomer(result.QueryResponse.Customer[0]))
