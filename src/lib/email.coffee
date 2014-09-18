email   = require("emailjs");
server  = email.server.connect
   user:    "df.consumer.team",
   password:"ondemand",
   host:    "smtp.gmail.com",
   ssl:     true

send = (business, customer) ->

  reviewLink = "https://local.intuit.com/e/review?bid=#{business.id}&cname=#{customer.name}"

  #  send the message and get a callback with an error or details of the message that was sent
  emailOpts =
    "content-type": "text/html"
    text:    '
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title>Thank You!</title>
    </head>
    <body>
    Thanks for your business.
    If you could leave a review on <a href="#{reviewLink}">Intuit Local</a>, I would really appreciate it!
    </body>
    </html>'

    from:    "#{business.name} <df.consumer.team@gmail.com>"
    to:      "#{customer.name} <#{customer.email}>"
    subject: "Thank you for your business!"

  console.dir emailOpts
  server.send emailOpts, (err, message) ->
    console.log err || message

module.exports = {send}
