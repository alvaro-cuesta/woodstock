Game = require '../models/game'

BOARD_WIDTH = 10
BOARD_HEIGHT = 10
BOARD_MINES = 10

GAME_SECONDS = 300
TURN_SECONDS = 10

games = []
waiting = null

exports.actions = (req, res, ss) ->
  new: ->
    player = req.socketId

    if waiting
      gameId = 0
      gameId++ while games[gameId]

      game = new Game BOARD_WIDTH, BOARD_HEIGHT, BOARD_MINES,
        GAME_SECONDS, TURN_SECONDS, [waiting, player]
      , (game) ->
        for player in game.players
          console.log 'Turn lost'
      , (game) ->
        for player in game.players
          ss.publish.socketId player, 'endGame', gameId, game
          delete games[gameId]

      games[i] = game

      ss.publish.socketId player, 'newGame', i, game
      ss.publish.socketId waiting, 'newGame', i, game

      waiting = null
      res true
    else
      waiting = player
      res false

  click: (gameId, x, y) ->
    game = games[gameId]
    
    if not game
      res false
      return 

    if game.players[game.turn] != req.socketId
      res false
      return

    if 0 <= x < game.width and 0 <= y < game.height
      game.uncover x, y

      if game.state[x][y] < 0  # There is a mine
        game.scores[game.turn] += 1
      else
        game.turn = (game.turn + 1) % game.players.length

      game.resetTurnTimeout()
      for player in game.players
        ss.publish.socketId player, 'updatedGame', gameId, game

      res true
    else
      res false

