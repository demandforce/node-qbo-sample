smtpapi   = require('smtpapi')
nodemailer = require('nodemailer')
header    = new smtpapi()

# Build the smtpapi header
header.addTo('brennan_payne@intuit.omc')
header.setUniqueArgs({cow: 'chicken'})

# Add the smtpapi header to the general headers
headers    = { 'x-smtpapi': header.jsonString() }

 # Use nodemailer to send the email
settings  =
  host: "smtp.sendgrid.net"
  port: parseInt(587, 10)
  requiresAuth: true
  auth:
    user: "brennanpayne",
    pass: "Supersmokey678"

smtpTransport = nodemailer.createTransport("SMTP", settings)

sendEmail = (business, customer) ->
  mailOptions =
    from:     "Intuit Local <admin@local.intuit.com>"
    to:       "brennan_payne@intuit.com"
    subject:  "Hello"
    text:     "Hello world"
    html:     "<b>Hello world</b>"
    headers:  headers


  smtpTransport.sendMail mailOptions, (error, response) ->
    smtpTransport.close()

    if (error)
      console.log(error)
    else
      console.log("Message sent: " + response.message)


exports = {sendEmail}
