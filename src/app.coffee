process.env.TZ = "UTC"
process.env.NODE_ENV ||= "development"
express = require('express')
app = express()
https = require("https")
fs = require("fs")
cors = require("cors")
path = require("path")
ect = (require 'ect')
  watch: true
  root: path.join __dirname, '/views'
  ext: '.ect'
privateKey = fs.readFileSync("src/config/certs/server.key")
certificate = fs.readFileSync("src/config/certs/server.crt")
credentials = {key: privateKey, cert: certificate}
app.use(cors())
app.set 'views', path.join(__dirname, '/views')
app.set 'view engine', 'ect'
app.engine 'ect', ect.render
app.use express.static 'src/public'

app.get "/test", (req, res, next) ->
  res.render("test")

httpsServer = https.createServer(credentials, app)
server = httpsServer.listen process.env.PORT || 3000, () ->
  console.log "Listening on #{server.address().port}"
