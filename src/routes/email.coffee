# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.post "/email", (req, res) ->
    business =
      name: req.body.businessName
      id: req.body.businessId

    customer =
      name: req.body.firstName
      email: req.body.email

    email.send(business, customer)
    res.send("sent", 200)
