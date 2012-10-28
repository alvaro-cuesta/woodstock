# Better time handling

Game = require '../models/game'

BOARD_WIDTH = 27
BOARD_HEIGHT = 17
BOARD_MINES = 10

GAME_SECONDS = 300
TURN_SECONDS = 10

games = []
waiting = null

notifyTurn = (game, ss) ->
  for player in game.players
    if game.players[game.turn] == player
      ss.publish.socketId player, 'yourTurn', game.id
    else
      ss.publish.socketId player, 'notYourTurn', game.id

newTurnTimeout = (game, ss) ->
  if game.turnTimeout
    clearTimeout game.turnTimeout

  game.turnTimeout = setTimeout ->
    clearTimeout game.globalTimeout
    notifyTurn(game, ss)
  , TURN_SECONDS * 1000

endGame = (game) ->
  if game.globalTimeout
    clearTimeout game.globalTimeout
  if game.turnTimeout
    clearTimeout game.turnTimeout
  for player in game.players
    ss.publish.socketId player, 'endGame', game.id
    delete games[game.id]

cleanGame = (game) ->
  id: game.id
  width: game.width
  height: game.height
  mines: game.mines
  gameDuration: game.gameDuration
  turnDuration: game.turnDuration
  players: game.players
  state: game.state
  turn: game.turn
  scores: game.scores

exports.actions = (req, res, ss) ->
  new: ->
    player = req.socketId

    if waiting
      gameId = 0
      gameId++ while games[gameId]

      game = new Game gameId, BOARD_WIDTH, BOARD_HEIGHT, BOARD_MINES,
        GAME_SECONDS, TURN_SECONDS, [waiting, player]

      games[gameId] = game

      ss.publish.socketId player, 'newGame', cleanGame(game)
      ss.publish.socketId waiting, 'newGame', cleanGame(game)
      ss.publish.socketId game.players[game.turn], 'yourTurn', gameId

      game.globalTimeout = setTimeout endGame, GAME_SECONDS * 1000
      newTurnTimeout(game, ss)
      notifyTurn(game, ss)

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

      newTurnTimeout(game, ss)
      for player, index in game.players
        ss.publish.socketId player, 'updatedGame', index, cleanGame(game)
 
      console.log game.turn

      res true
    else
      res false

