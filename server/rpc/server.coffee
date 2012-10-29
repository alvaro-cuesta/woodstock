Game = require '../controllers/game'

PLAYERS_PER_GAME = 2

## Game list ##

waiting = []
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
  req.use('session')

  new: ->
    if req.sessionId in (x.session for x in waiting)
      res false
      return

    if waiting.length < PLAYERS_PER_GAME
      waiting.push
        nick: req.session.nick
        session: req.sessionId
        socket: req.socketId
      res true

    if waiting.length == PLAYERS_PER_GAME
      # Find a free game id and create game
      gameId = 0
      gameId++ while games[gameId]
      games[gameId] = game = new Game gameId, waiting

      res true

      game.sendAll('newGame', ss)
      game.setGlobalTimer(ss)
      game.resetTurnTimer(ss)

      # Update game stats
      stats.played += 1
      stats.inProgress += 1
      syncStats(ss)

      waiting = []

    console.log (x.nick for x in waiting)
    ss.publish.all 'waiting', (x.nick for x in waiting) or []

  ## Sync server status ##

  update: ->
    console.log waiting
    ss.publish.socketId req.socketId, 'stats', stats
    ss.publish.socketId req.socketId, 'waiting', (x.nick for x in waiting) or []
    res true
