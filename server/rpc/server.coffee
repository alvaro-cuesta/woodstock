Game = require '../controllers/game'

## Game list ##

waiting = false
games = []

## Statistics ##

stats =
  played: 0
  inProgress: 0
  found: 0

syncStats = (ss) ->
  ss.publish.all 'stats', stats

## Exports ##

exports.games = games

exports.found = (ss) ->
  stats.found += 1
  syncStats(ss)

exports.removeGame = (game, ss) ->
  delete games[game.id]
  stats.inProgress -= 1
  syncStats(ss)

exports.actions = (req, res, ss) ->
  new: ->
    player = req.socketId

    if not waiting
      waiting = player
    else
      # Find a free game id and create game
      gameId = 0
      gameId++ while games[gameId]
      games[gameId] = game = new Game gameId, [waiting, player]

      game.sendAll('newGame', ss)
      game.setGlobalTimer(ss)
      game.resetTurnTimer(ss)

      # Update game stats
      stats.played += 1
      stats.inProgress += 1
      syncStats(ss)

      waiting = false

    ss.publish.all 'waiting', waiting
    res waiting == false

  ## Sync server status ##

  update: ->
    ss.publish.socketId req.socketId, 'stats', stats
    ss.publish.socketId req.socketId, 'waiting', waiting
    res true
