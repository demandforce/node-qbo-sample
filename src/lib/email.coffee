email   = require("emailjs");
server  = email.server.connect
   user:    "df.consumer.team",
   password:"ondemand",
   host:    "smtp.gmail.com",
   ssl:     true

ECT = require('ect')

path = require("path")

send = (business, customer) ->
  reviewLink = "https://local.intuit.com/e/reviews?_e=6DA0433A9D4C823E9A751C97721FDAF21200ACECB2400D854BCE849B3C8F10CB21F85FBF11A3BB7DA587B5741205BDCDCA7205FAEB7277827CA52CA498012E47C1AA19012E8B09FF66ACEE5162E286A42B8A84CC017906285165527D793E9DDFA5D4C30E8BCFFF15076E45AC689A1349001644033812B5DF510FDCCCA59F7F203191DBB5DD05DAE063F8F85EDDF94443CCCE875EDDBA7EEF421DF1CF724FE187"

  root   = path.resolve(__dirname, "../..")
  emails = path.resolve(root, "src/emails")
  renderer = ECT(root : emails, ext : '.ect' )
  locals =
    reviewLink: reviewLink

  html = renderer.render('review', locals )
  emailOpts =
    "content-type": "text/html"
    text: html
    from:    "#{business.name} <df.consumer.team@gmail.com>"
    to:      "#{customer.name} <brennan_payne@intuit.com>"
    subject: "Thanks for your business!"

  #  send the message and get a callback with an error or details of the message that was sent
  server.send emailOpts, (err, message) ->
    console.log err || message

module.exports = {send}
