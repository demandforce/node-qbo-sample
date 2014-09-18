# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.get "/email", (req, res) ->    
    business =
      name: req.query.businessName
      id: req.query.businessId

    customer =
      name: req.query.firstName
      email: req.query.email

    email.send(business, customer)
    res.send("sent", 200)
