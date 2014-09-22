QuickBooks = require('node-quickbooks')
qs         = require('querystring')
request    = require('request')
credentials = require("../config/credentials")[process.env.NODE_ENV]

module.exports = (app) ->
  app.get '/login', (req, res) ->
    res.render('oauth.ect', port: app.PORT)

  app.get '/requestToken', (req, res) ->
    postBody =
      url: QuickBooks.REQUEST_TOKEN_URL,
      oauth:
        callback:        'http://localhost:' + app.PORT + '/callback/',
        consumer_key:    credentials.consumerKey
        consumer_secret: credentials.consumerSecret
    request.post postBody, (error, result, data) ->
      requestToken = qs.parse(data)
      req.session.oauth_token_secret = requestToken.oauth_token_secret
      res.redirect(QuickBooks.APP_CENTER_URL + requestToken.oauth_token)


  app.get '/callback', (req, res) ->
    postBody =
      url: QuickBooks.ACCESS_TOKEN_URL,
      oauth:
        consumer_key:    credentials.consumerKey,
        consumer_secret: credentials.consumerSecret,
        token:           req.query.oauth_token,
        token_secret:    req.session.oauth_token_secret,
        verifier:        req.query.oauth_verifier,
        realmId:         req.query.realmId

    request.post postBody, (errror, result, data) ->
      accessToken = qs.parse(data)

      # save the oauth token and access token secret
      # somewhere on behalf of the logged in user
      console.log("Oauth Token: #{accessToken.oauth_token}")
      console.log("Oauth Token Secret: #{accessToken.oauth_token_secret}")
      qbo = new QuickBooks(credentials.consumerSecret,
                           credentials.consumerSecret,
                           accessToken.oauth_token,
                           accessToken.oauth_token_secret,
                           req.query.realmId,
                           true); # turn debugging on

      qbo.getCompanyInfo req.query.realmId, (err, result) ->
        console.log(result)

      # test out account access
    # close the current window
    res.send('<html><body><script>window.close()</script>')
