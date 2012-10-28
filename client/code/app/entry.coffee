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

    board = new Board 0, BOARD_WIDTH, BOARD_HEIGHT
    board.appendTo $('#board')
    player_is_high = false;

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