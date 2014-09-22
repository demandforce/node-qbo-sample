# QBO-Sample-Node
 * node.js for blazing fast app development
 * coffeescript for all the syntactic sugar
 * ect templates for some coffee in your views
 * express.js so you can concentrate on app logic
 * node-quickbooks module to make working with the QBO APIs a breeze

## Getting Started with the app
* Install dependencies with: `npm install`
* Start serving requests: `npm start`

## Geting oauth token and secret
* You will need your app's consumer key and consumer secret. You can get this from  
 the My Apps section in the [Intuit Developer Portal](https://qa-developer.intuit.com/v2)  
* To get the oauth token and oauth secret, you need to go through the OAUTH exchange flow  

Run `npm start`. This will start an http server running on port 8080. Browsing to http://localhost:8080/login will display a page containing only the IPP Javascript-rendered button, kicking off the OAuth exchange. Note that the IPP Javascript code contained in `intuit.ejs` is configured with the `grantUrl` option set to "http://localhost:8080/requestToken". You will want to change this to an appropriate URL for your application, but you will need to write similar functionality to that contained in the  '/requestToken' route configured in `app.js`, also taking care to configure your `consumerKey` and `consumerSecret` on lines 27-28 in app.js.

The IPP Javascript code calls back into the node application, which needs to invoke the OAuth Request Token URL at https://oauth.intuit.com/oauth/v1/get_request_token via a server-side http POST method. Note how the response from the http POST is parsed and the browser is redirected to the App Center URL at https://appcenter.intuit.com/Connect/Begin?oauth_token= with the `oauth_token` passed as a URL parameter. Note also how the `oauth_token_secret` needs to somehow be maintained across http requests, as it needs to be passed in the second server-side http POST to the Access Token URL at https://oauth.intuit.com/oauth/v1/get_access_token. This final step is invoked once the user has authenticated on Intuit's site and authorized the application, and then the user is redirected back to the node application at the callback URL specified as a parameter in the Request Token remote call, in the example app's case, http://localhost:8080/callback.


## License
Copyright (c) 2014 Intuit, Inc.  
