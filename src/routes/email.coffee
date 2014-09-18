
module.exports = (app) ->
  app.post "sendEmail", (req, res, next) ->
    SendGrid.sendEmail("Business!", "Customer!")
    res.send "Sent (Asynchornously)"
