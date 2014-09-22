process.env.TZ = "UTC"
# do no harm, development by default
process.env.NODE_ENV ||= "development"
express = require('express')
app = express()
http = require("http")
bodyParser = require("body-parser")
fs = require("fs")
cors = require("cors")
path = require("path")
session = require('express-session')
ect = (require 'ect')
  watch: true
  root: path.join __dirname, '/views'
  ext: '.ect'

File   = require("fs")
root   = path.resolve(__dirname, "..")
routes = path.resolve(root, "src/routes")

# cors support
app.use(cors())

# ect view engine
app.set 'views', path.join(__dirname, '/views')
app.set 'view engine', 'ect'
app.engine 'ect', ect.render

# static files
app.use express.static 'src/public'

# request body parser
app.use(bodyParser.json())

# enable sessions
app.use(session({secret: 'brad smith'}))

PORT = process.env.PORT || 8080
app.PORT = PORT

# load routes
for file in fs.readdirSync(routes)
  require("#{routes}/#{file}")(app)

httpServer = http.createServer(app)

# if you need an https server
# privateKey = fs.readFileSync("src/config/certs/server.key")
# certificate = fs.readFileSync("src/config/certs/server.crt")
# credentials = {key: privateKey, cert: certificate}
# httpServer = http.createServer(app, credentials)
server = httpServer.listen PORT, () ->
  console.log "Listening on #{server.address().port}"
