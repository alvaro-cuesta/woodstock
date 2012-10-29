window.ss = require 'socketstream'

require '/psicodelia'
require '/newgame'
require '/game'
require '/timers'
require '/footer'

## Synchronize on connect/reconnect ##

ss.server.on 'ready', ->
  jQuery ->
    ss.rpc('game.synchronize')

ss.server.on 'reconnect', ->
  ss.rpc('game.synchronize')

## Logging ##

ss.event.on 'newGame', (game) ->
  console.log "Starting game #{game.id}"
  console.log game

ss.event.on 'updatedGame', (playerId, game) ->
  console.log "Updated game #{game.id}. You are player #{playerId}."
  console.log game

ss.event.on 'endGame', (playerId, game) ->
  console.log "Finished game #{game.id}"
  console.log game

ss.event.on 'yourTurn', (game) ->
  console.log "Your turn in game #{game.id}"
  console.log game

ss.event.on 'notYourTurn', (game) ->
  console.log "Not your turn in game #{game.id}"
  console.log game
