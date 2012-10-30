window.ss = require 'socketstream'

require '/psicodelia'
require '/newgame'
require '/game'
require '/sidebar'
require '/timers'
require '/footer'
time = require '/time'

## Synchronize on connect/reconnect ##

ss.server.on 'connect', ->
  jQuery ->
    ss.rpc('server.status')
    time.sync()

## Logging ##

ss.event.on 'waiting', (waiting) ->
  console.log "[SERVER] Waiting:", waiting

ss.event.on 'stats', (stats) ->
  console.log "[SERVER] Stats: ", stats

ss.event.on 'newGame', (player, game) ->
  console.log "#{game.id}[#{player}] NEW", game

ss.event.on 'updatedGame', (player, game) ->
  console.log "#{game.id}[#{player}] UPDATE", game

ss.event.on 'endGame', (player, game) ->
  console.log "#{game.id}[#{player}] END", game
