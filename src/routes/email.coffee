# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.post "/sendEmail", (req, res) ->

    business =
      name: "Brennan's Body Shop"
      slug: "brennans-body"

    customer =
      name: "Brennan Payne"
      email: "brennan_payne@intuit.com"
    email.send(business, customer)
    res.send("sent", 200)
