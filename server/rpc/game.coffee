Server = require './server'

exports.actions = (req, res, ss) ->
  click: (gameId, x, y) ->
    game = Server.games[gameId]
    
    # Check if game exists
    if not game
      res false
      return 

    # Check player turn
    if game.players[game.turn] != req.socketId
      res false
      return

    # Check click bounds
    if not (0 <= x < game.width) or not (0 <= y < game.height)
      res false
      return

    # Check if tile is uncoverable
    if game.state[x][y] != false
      res false
      return

    game.uncover(x, y, ss)  # Do the magic, baby

    if game.state[x][y] < 0
      Server.found(ss)
      game.scores[game.turn] += 1
      game.resetTurnTimer(ss)

      # Check if game finished
      totalScore = game.scores.reduce (t, s) -> t + s
      game.end(ss) if totalScore == game.mines
    else
      game.newTurn(ss)

    res true
