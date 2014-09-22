QuickBooks = require('node-quickbooks')
# change these values before you test
credentials = require('../src/config/credentials')[process.env.NODE_ENV || "test"]
consumerKey = credentials.consumerKey
consumerSecret = credentials.consumerSecret

qbo = new QuickBooks(consumerKey,
                     consumerSecret,
                     "oauth token",
                     "oauth token secret - change me",
                     "realmid - change me",
                         true)
qbo.getCompanyInfo "realmid - changeme", (err, result) ->
  console.log result
