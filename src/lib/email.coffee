email   = require("emailjs");
server  = email.server.connect
   user:    "df.consumer.team",
   password:"ondemand",
   host:    "smtp.gmail.com",
   ssl:     true


send = (business, customer) ->

  console.log business
  console.log customer
  #  send the message and get a callback with an error or details of the message that was sent
  emailOpts =
    text:    "i hope this works"
    from:    "Intuit Local <df.consumer.team@gmail.com>"
    to:      "#{customer.name} <brennan_payne@intuit.com>"
    subject: "testing emailjs"

  server.send emailOpts, (err, message) ->
    console.log err || message

module.exports = {send}
