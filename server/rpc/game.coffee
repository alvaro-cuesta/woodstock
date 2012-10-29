Server = require './server'

exports.actions = (req, res, ss) ->
  click: (gameId, x, y) ->
    console.log Server.games
    game = Server.games[gameId]
    
    # Check if game exists
    if not game
      res "Game #{gameId} does not exist."
      return 

    # Check player turn
    if game.players[game.turn].socket != req.socketId
      res "It's not your turn."
      return

    # Check click bounds
    if not (0 <= x < game.width) or not (0 <= y < game.height)
      res "#{x},#{y} is out of bounds."
      return

    # Check if tile is uncoverable
    if game.state[x][y] != false
      res "#{x},#{y} is already clicked."
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

    res false
