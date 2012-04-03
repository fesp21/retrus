ss = require("socketstream")

connect = require("connect")
express = require("express")
require("express-resource")
nohm = require('nohm').Nohm
redisClient = require('redis').createClient()
nohm.setClient(redisClient)

app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname + "/app/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use connect.logger()
  app.use app.router
  app.use ss.http.middleware
  app.set 'view options',
    title: false

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", require("./app/routes/index").index
app.resource "retrospectives", require("./app/routes/retrospectives")

app.get "/chat", (req, res) ->
  res.serveClient "main"

ss.client.define "main",
  view: "app.jade"
  css: [ "libs", "app.styl" ]
  code: [ "libs", "app" ]
  tmpl: "*"

ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")
ss.client.packAssets() if ss.env is "production"

if !module.parent
  server = app.listen 3000
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
  ss.start server
  console.log "Socket stream started"

