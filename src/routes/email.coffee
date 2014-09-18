# EMAIL
email = require('../lib/email.coffee')

module.exports = (app) ->
  app.post "/email", (req, res) ->

    business =
      name: "Vibe Yoga"
      slug: "vibe-yoga"

    customer =
      name:
        first: "Brennan"
        last: "Payne"
      email: "brennan_payne@intuit.com"
    email.send(business, customer)
    res.send("sent", 200)
