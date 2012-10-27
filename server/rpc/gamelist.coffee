Game = require '../models/game'

BOARD_WIDTH = 10
BOARD_HEIGHT = 10
BOARD_MINES = 10

GAME_SECONDS = 300
TURN_SECONDS = 10

list =
  active: []
  finished: []
  waiting: null

exports.actions = (req, res, ss) ->
  req.use('session')
  req.use('authentication.check')

  active: ->
    res list.active

  finished: ->
    res list.finished

  play: ->
    player = req.session.userId

    if waiting
      game = new Game BOARD_WIDTH, BOARD_HEIGHT, BOARD_MINES,
        GAME_SECONDS, TURN_SECONDS, [waiting, player]
      ss.publish.all 'newGame', game
      res game
    else
      waiting = player
      res false