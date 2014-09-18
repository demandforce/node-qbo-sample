QuickBooks = require('node-quickbooks')
qboCompany = {}
consumerKey = "qye2eXzQ3VKFhxbgS9MmBeocbpHZ6E"
consumerSecret = "OkGnidNxy3xxKdxdaI2uvI6PSzF2WP4ir5gh1yap"
oauthToken = "qye2enT6Duekw3S4UVxKs9nLJ0WcETb7xcyMXbQqLqcTiw4r"
oauthSecret = "qNtyLwlbAWXNh463x7mwrpiDYmL1AbnqjF5kiig3"

# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.get "/invoices/:companyId", (req, res) ->
    companyId = req.params.companyId
    qbo = qboCompany.companyId
    unless qbo
      qbo = new QuickBooks(consumerKey, consumerSecret, oauthToken, oauthSecret, companyId)

  app.post "/sendEmail", (req, res) ->
    business =
      name: "Brennan's Body Shop"
      slug: "brennans-body"

    customer =
      name: "Brennan Payne"
      email: "brennan_payne@intuit.com"
    email.send(business, customer)
    res.send("sent", 200)
