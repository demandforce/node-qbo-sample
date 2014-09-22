# QBO-Sample-Node
 * node.js for blazing fast app development
 * coffeescript for all the syntactic sugar
 * ect templates for some coffee in your views
 * express.js so you can concentrate on app logic
 * node-quickbooks module to make working with the QBO APIs a breeze

## Getting Started with the app
* Install dependencies with: `npm install`
* Start serving requests: `npm start`  
`npm start` starts a [forever](https://github.com/nodejitsu/forever) process, that watches for changes in your app, and automatically restarts the node server. If you dont care about this, you can also run `node_modules/coffee-script/bin/coffee src/app.coffee`

## Geting oauth token and secret
* You will need your app's consumer key and consumer secret configured in `src/config/credentials.json`. You can get this from  
 the My Apps section in the [Intuit Developer Portal](https://qa-developer.intuit.com/v2)  
* To get the oauth token and oauth secret, you need to go through the OAUTH exchange flow  

  The relevant oauth exchange urls are available in node_modules/node-quickbooks/index.js

  * QuickBooks.REQUEST_TOKEN_URL        = 'https://oauth.intuit.com/oauth/v1/get_request_token'
  * QuickBooks.ACCESS_TOKEN_URL         = 'https://oauth.intuit.com/oauth/v1/get_access_token'
  * QuickBooks.APP_CENTER_URL           = 'https://appcenter.intuit.com/Connect/Begin?oauth_token='
  * QuickBooks.V3_ENDPOINT_BASE_URL     = 'https://quickbooks.api.intuit.com/v3/company/'
  * QuickBooks.PAYMENTS_API_V2_BASE_URL = 'https://transaction-qa.payments.intuit.net/v2'

  If you are using a qa account, you will want to change this to the corresponding qa account urls. Make sure these urls are right, otherwise you will get a 401 from the QBO APIs

  * QuickBooks.REQUEST_TOKEN_URL        = 'https://oauthws.e2e.qdc.ep.intuit.net/oauth/v1/get_request_token'
  * QuickBooks.ACCESS_TOKEN_URL         = 'https://oauthws.e2e.qdc.ep.intuit.net/oauth/v1/get_access_token'
  * QuickBooks.APP_CENTER_URL           = 'https://qa-appcenter.intuit.com/Connect/Begin?oauth_token='
  * QuickBooks.V3_ENDPOINT_BASE_URL     = 'https://qbo.qa.sbfinance.stage.intuit.com/v3/company/'
  * QuickBooks.PAYMENTS_API_V2_BASE_URL = 'https://transaction-api-qal.payments.intuit.com/qa2/v2'

  Run `npm start`. This will start an http server running on port 8080. Browsing to http://localhost:8080/login will display a page containing only the IPP Javascript-rendered button, kicking off the OAuth exchange. Note that the IPP Javascript code contained in `src/views/oauth.ect` is pointing to this url: `"https://qa-appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js"` . If you are using the production app-center url, you will want to change this to `"https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js"` is configured with the `grantUrl` option set to "http://localhost:8080/requestToken". You might want to change this to an appropriate URL for your application, but you will need to write similar functionality to that contained in the  '/requestToken' route configured in `src/routes/oauth.coffee`.

  The IPP Javascript code calls back into the node application, which needs to invoke the OAuth Request Token URL at https://oauth.intuit.com/oauth/v1/get_request_token via a server-side http POST method. Note how the response from the http POST is parsed and the browser is redirected to the App Center URL at https://appcenter.intuit.com/Connect/Begin?oauth_token= with the `oauth_token` passed as a URL parameter. Note also how the `oauth_token_secret` needs to somehow be maintained across http requests, as it needs to be passed in the second server-side http POST to the Access Token URL at https://oauth.intuit.com/oauth/v1/get_access_token. This final step is invoked once the user has authenticated on Intuit's site and authorized the application, and then the user is redirected back to the node application at the callback URL specified as a parameter in the Request Token remote call, in the example app's case, http://localhost:8080/callback. If you just want to spit out the oauth token and secret, you can look at the console logs for the values, and use these to test the QBO APIs
  
## APIs
  Once you have the consumer key, consumer secret, oauth token, oauth token secret and realmId(companyId), take a look at `src/routes/index.coffee`. Make sure you change the oauth token and oauth token secret to the values you obtained from the previous step(or read from your db if you are not storing them in the app). The following APIs will then work:
  * `/company/:companyId/invoices`: Renders page with the 10 most most recent invoices along with the customer and company information (html).
  * `/company/:companyId`: Renders information about the company (json)
  * `/company/:companyId/customers`: Renders all the customers in the company (json)
  * `/company/:companyId/customer/:customerId`: Renders information about a particular customer (json)

## Test
  You can also run `node_modules/coffee-script/bin/coffee test/qbo_test.coffee` to test if your credentials work fine. Make sure you replace you replace the `consumerKey` and `consumerSecret` values in `src/config/credentials.json` and also, the oauth token and oauth token secret values in the test file.
  


## License
Copyright (c) 2014 Intuit, Inc.  
