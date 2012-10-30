http = require('http')
ss = require('socketstream')
Stats = require('./server/lib/stats')
Room = require('./server/lib/room')
Game = require('./server/lib/game')

# Extend RPC API
ss.api.add 'stats', new Stats('./stats.json', ss.api)
ss.api.add 'room', new Room(Game, {}, 2, ss.api)

# Main view
main =
  view: 'app.jade'
  tmpl: '*'
  css: ['libs/foundation.css', 'app.less']
  code: [
    'libs/jquery.min.js'
    'libs/jquery.foundation.mediaQueryToggle.js'
    'libs/jquery.foundation.forms.js'
    'libs/jquery.foundation.reveal.js'
    'libs/jquery.foundation.orbit.js'
    'libs/jquery.foundation.navigation.js'
    'libs/jquery.foundation.buttons.js'
    'libs/jquery.foundation.tabs.js'
    'libs/jquery.foundation.tooltips.js'
    'libs/jquery.foundation.accordion.js'
    'libs/jquery.placeholder.js'
    'libs/jquery.foundation.alerts.js'
    'libs/jquery.foundation.topbar.js'
    'libs/modernizr.foundation.js'
    'libs/app.js'
    'app'
    'views'
    'piv'
  ]

ss.client.define 'main', main

ss.http.route '/', (req, res) ->
  console.log 'ss', ss
  console.log 'req',req
  console.log 'res',res
  console.log "Client #{req.sessionID} joined"
  req.on 'close', ->
    console.log "Client #{req.sessionID} lost"
  req.on 'end', ->
    console.log "Client #{req.sessionID} left"
  res.serveClient('main')

# Middleware
ss.client.formatters.add require('ss-coffee')
ss.client.formatters.add require('ss-jade')
ss.client.formatters.add require('./ss-less')
ss.client.templateEngine.use require('ss-hogan')

# Minify in production
if ss.env == 'production'
  ss.client.packAssets() 

# Start servers
server = http.Server(ss.http.middleware)
server.listen(3000)
consoleServer = require('ss-console')(ss)
consoleServer.listen(5000)

ss.start(server)