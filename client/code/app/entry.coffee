## Pirado's code

Gradation = require '/gradation'
Cloud = require '/cloud'
Canvas = require '/canvas'
Board = require '/board'

BOARD_WIDTH = 27
BOARD_HEIGHT = 17

canvas = null
gradation = null
clouds = []
timer = 30

for i in [1:100]
  clouds.push new Cloud

##

window.ss = require 'socketstream'

ss.server.on 'disconnect', ->
  console.log('Connection down :-(')

ss.server.on 'reconnect', ->
  console.log('Connection back up :-)')

ss.server.on 'ready', ->
  jQuery ->
    $('#newGame').click ->
      ss.rpc 'game.new', (ready) =>
        if ready
          $(this).fadeOut();
        else
          $(this).attr("disabled", true).text('Waiting for player...')

    canvas = new Canvas
    gradation = new Gradation

    canvas.draw()
    gradation.draw(canvas)

    player_is_high = false;

ss.event.on 'newGame', (game) ->
  console.log "Starting game #{game.id}"
  console.log game

  $board = $('#board')
  board = new Board game.id, game.width, game.height
  $board.html ''
  board.appendTo $board

  $('#player-points').text '0'
  $('#oponent-points').text '0'
  $('#newGame').hide()

ss.event.on 'updatedGame', (playerId, game) ->
  console.log "Updated game #{game.id}. You are player #{playerId}."
  console.log game

  $board = $('#board')
  board = new Board game.id, game.width, game.height
  for x in [0..(game.width-1)]
    for y in [0..(game.height-1)]
      board.tiles[x][y].set game.state[x][y]
  $board.html ''
  board.appendTo $board

  $('#player-points').text game.scores[playerId]
  $('#oponent-points').text game.scores[(playerId + 1) % 2]

ss.event.on 'endGame', (gameId) ->
  console.log "Finished game #{gameId}"
  console.log game

  $ '#newGame'
    .show()
    .attr 'disabled', false
    .text 'New game'

ss.event.on 'yourTurn', (gameId) ->
  console.log "Your turn in game #{gameId}"
  console.log game

  $('#turn-title')
    .addClass('your-turn')
    .removeClass('opponent-turn')
    .text('Your turn')

ss.event.on 'notYourTurn', (gameId) ->
  console.log "Not your turn in game #{gameId}"
  console.log game

  $('#turn-title')
    .removeClass('your-turn')
    .addClass('opponent-turn')
    .text("Opponent's turn")

module.exports.looper = ->
  canvas.update();
  canvas.draw();

  for i in clouds
    clouds[i].update()
    clouds[i].draw()

  gradation.update();
  gradation.draw canvas

  setTimeout looper, timer

# Esta funcion activa la psicodelia
module.exports.high = ->
  if not player_is_high
    player_is_high = true
    for i in clouds
      clouds[i].opacitySpeed 0.005

    looper();