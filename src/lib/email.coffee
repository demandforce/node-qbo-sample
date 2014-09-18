email   = require("emailjs");
server  = email.server.connect
   user:    "df.consumer.team",
   password:"ondemand",
   host:    "smtp.gmail.com",
   ssl:     true

send = (business, customer) ->

  console.log business
  console.log customer
  reviewLink = "https://local.intuit.com/e/reviews?_e=6DA0433A9D4C823E9A751C97721FDAF21200ACECB2400D854BCE849B3C8F10CB21F85FBF11A3BB7DA587B5741205BDCDCA7205FAEB7277827CA52CA498012E47C1AA19012E8B09FF66ACEE5162E286A42B8A84CC017906285165527D793E9DDFA5D4C30E8BCFFF15076E45AC689A1349001644033812B5DF510FDCCCA59F7F203191DBB5DD05DAE063F8F85EDDF94443CCCE875EDDBA7EEF421DF1CF724FE187"

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
    Thanks for your business.  I like to reach out to customers and see how their visit went and if there is anything I can improve upon.
    If you could leave a review on <a href=#{reviewLink}>Intuit Local</a>, I would really appreciate it!
    </body>
    </html>'

    from:    "#{business.name} <df.consumer.team@gmail.com>"
    to:      "#{customer.name} <brennan_payne@intuit.com>"
    subject: "Thanks for your business!"

  server.send emailOpts, (err, message) ->
    console.log err || message

module.exports = {send}
