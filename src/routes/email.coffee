# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.post "/email", (req, res) ->
    business =
      name: req.body.business.name
      id: req.body.business.id

    customer =
      name: req.body.customer.firstname
      email: req.body.customer.email

    email.send(business, customer)
    res.send("sent", 200)
