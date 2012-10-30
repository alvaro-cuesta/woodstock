player = ->
  (req, res, next) ->
    req.player =
      nick: req.session.nick
      session: req.sessionId
      socket: req.socketId
    return next()

exports.actions = (req, res, ss) ->
  req.use('session')
  req.use(player)

  new: ->
    res ss.room.addPlayer req.player

  click: (gameId, x, y) ->
    game = ss.room.games[gameId]
    res game.click(req.player, x, y, ss) if game?
