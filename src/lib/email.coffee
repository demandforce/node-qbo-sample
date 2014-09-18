email   = require("emailjs");
server  = email.server.connect
   user:    "df.consumer.team",
   password:"ondemand",
   host:    "smtp.gmail.com",
   ssl:     true

ECT = require('ect')

path = require("path")

  
send = (business, customer) ->
  reviewLink = "https://localhost:8080/e/review?bid=#{business.id}&cname=#{customer.name}"
  root   = path.resolve(__dirname, "../..")
  emails = path.resolve(root, "src/emails")
  renderer = ECT(root : emails, ext : '.ect' )
  locals =
    reviewLink: reviewLink
    businessName: business.name
    customerName: customer.name

  html = renderer.render('review', locals )
  emailOpts =
    "content-type": "text/html"
    text: html
    from:    "#{business.name} <df.consumer.team@gmail.com>"
    to:      "#{customer.name} <#{customer.email}>"
    subject: "Thank you for your business!"

  console.dir emailOpts
  server.send emailOpts, (err, message) ->
    console.log err || message

module.exports = {send}
