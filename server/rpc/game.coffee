# TODO:
#  Rematch

exports.actions = (req, res, ss) ->
  req.use('session')
  req.use('authentication')

  uncover: (game, x, y) ->
    if game.players[game.turn] == req.session.userId
      game.uncover x, y

      if game.state[x][y] < 0  # There is a mine
        game.scores[game.turn] += 1
      else
        game.turn = (game.turn + 1) % game.players.length

      game.resetTimeout()
      res game

  leave: (game) ->
    0