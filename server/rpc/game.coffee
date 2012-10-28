# Better time handling

Game = require '../models/game'

BOARD_WIDTH = 27
BOARD_HEIGHT = 17
BOARD_MINES = 52

GAME_SECONDS = 180
TURN_SECONDS = 7

games = []
waiting = null

epoch = ->
  parseInt(+new Date / 1000)

stats =
  played: 0
  inProgress: 0
  found: 0

sendStats = (ss) ->
  ss.publish.all 'stats', stats

changeTurn = (game, ss) ->
  game.turn = (game.turn + 1) % game.players.length
  game.endTurn = epoch() + TURN_SECONDS

  for player in game.players
    if game.players[game.turn] == player
      ss.publish.socketId player, 'yourTurn', cleanGame(game)
    else
      ss.publish.socketId player, 'notYourTurn', cleanGame(game)

newTurnTimeout = (game, ss) ->
  if game.turnTimeout
    clearTimeout game.turnTimeout

  game.turnTimeout = setTimeout ->
    newTurnTimeout(game, ss)
    changeTurn(game, ss)
  , TURN_SECONDS * 1000

endGame = (game, ss) ->
  if game.globalTimeout
    clearTimeout game.globalTimeout
  if game.turnTimeout
    clearTimeout game.turnTimeout
  for player, index in game.players
    ss.publish.socketId player, 'endGame', index, game
    delete games[game.id]
  stats.inProgress -= 1
  sendStats(ss)

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
  endEpoch: game.endEpoch
  endTurn: game.endTurn

exports.actions = (req, res, ss) ->
  new: ->
    player = req.socketId

    if waiting
      gameId = 0
      gameId++ while games[gameId]

      game = new Game gameId, BOARD_WIDTH, BOARD_HEIGHT, BOARD_MINES,
        epoch() + GAME_SECONDS, epoch() + TURN_SECONDS, [waiting, player]

      games[gameId] = game

      stats.played += 1
      stats.inProgress += 1
      sendStats(ss)

      ss.publish.all 'waiting', false
      ss.publish.socketId player, 'newGame', cleanGame(game)
      ss.publish.socketId waiting, 'newGame', cleanGame(game)
      ss.publish.socketId game.players[game.turn], 'yourTurn', cleanGame(game)

      game.globalTimeout = setTimeout ->
        endGame(game, ss)
      , GAME_SECONDS * 1000
      newTurnTimeout(game, ss)
      changeTurn(game, ss)

      waiting = null
      res true
    else
      ss.publish.all 'waiting', true
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

    if not (0 <= x < game.width and 0 <= y < game.height)
      res false
      return

    if game.state[x][y] != false
      res false
      return

    console.log game.state
    game.uncover(x, y)
    if game.state[x][y] < 0  # There is a mine
      stats.found += 1
      sendStats(ss)
      game.scores[game.turn] += 1
      totalMines = game.scores.reduce (t, s) -> t + s
      if totalMines == game.mines
        endGame(game, ss)
        return
    else
      changeTurn(game, ss)

    newTurnTimeout(game, ss)
    for player, index in game.players
      ss.publish.socketId player, 'updatedGame', index, cleanGame(game)

    res true

  getStats: ->
    ss.publish.socketId req.socketId, 'stats', stats
    ss.publish.socketId req.socketId, 'waiting', waiting
    res true