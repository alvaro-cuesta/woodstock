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
  $('#game-status')
    .removeClass('connected')
    .addClass('not-connected')
    .text('Disconnected')

ss.server.on 'reconnect', ->
  ss.rpc('game.getStats')
  $('#game-status')
    .addClass('connected')
    .removeClass('not-connected')
    .text('Connected')

ss.server.on 'ready', ->
  jQuery ->
    ss.rpc('game.getStats')
    $('#game-status')
      .addClass('connected')
      .removeClass('not-connected')
      .text('Connected')

    $('#newGame').click ->
      ss.rpc 'game.new', (ready) =>
        if ready
          $(this).fadeOut();
        else
          $(this).attr("disabled", true).text('Waiting for player...')
          $(this).unbind('click')

    canvas = new Canvas
    gradation = new Gradation

    canvas.draw()
    gradation.draw(canvas)

    player_is_high = false;

newGameText = 'New game'
ss.event.on 'waiting', (waiting) ->
  $newGame = $('#newGame')
  newGameText = if waiting then 'Join waiting player' else 'New game'
  $newGame.text(newGameText)

timeIntervalGlobal = null
timeIntervalTurn = null
epoch = ->
  parseInt(+new Date / 1000)
pad2 = (number) ->
  (if number < 10 then '0' else '') + number

drawTime = (remaining) ->
  "#{pad2(parseInt(remaining / 60))}:#{pad2(parseInt(remaining % 60))}"

updateTurnInterval = (game) ->
  if timeIntervalTurn
    clearInterval timeIntervalTurn
    timeIntervalTurn = null

  remainingTurn = game.endTurn - epoch()
  $('#turn-time').text(drawTime(remainingTurn))
  timeIntervalTurn = setInterval ->
    remainingTurn = game.endTurn - epoch()
    $('#turn-time').text(drawTime(remainingTurn))
  , 1000

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

  remainingGlobal = game.endEpoch - epoch()
  $('#game-time').text(drawTime(remainingGlobal))
  timeIntervalGlobal = setInterval ->
    remainingGlobal = game.endEpoch - epoch()
    $('#game-time').text(drawTime(remainingGlobal))
  , 1000

  updateTurnInterval(game)

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

  updateTurnInterval(game)

ss.event.on 'endGame', (playerId, game) ->
  console.log "Finished game #{game.id}"
  console.log game

  $board = $('#board')
  board = new Board game.id, game.width, game.height
  for x in [0..(game.width-1)]
    for y in [0..(game.height-1)]
      board.tiles[x][y].set game.state[x][y]
  $board.html ''
  board.appendTo $board

  clearInterval timeIntervalGlobal
  clearInterval timeIntervalTurn
  timeIntervalGlobal = null
  timeIntervalTurn = null

  remainingGlobal = game.endEpoch - epoch()
  $('#game-time').text(drawTime(remainingGlobal))
  remainingTurn = game.endTurn - epoch()
  $('#turn-time').text(drawTime(remainingTurn))

  $('#player-points').text game.scores[playerId]
  $('#oponent-points').text game.scores[(playerId + 1) % 2]

  if game.scores[playerId] > game.scores[(playerId + 1) % 2]
    $('#turn-title')
      .addClass('your-turn')
      .removeClass('opponent-turn')
      .text('You won!')
  else
    $('#turn-title')
      .removeClass('your-turn')
      .addClass('opponent-turn')
      .text('You lose...')

  $('#newGame')
    .show()
    .attr('disabled', false)
    .text(newGameText)
    .click ->
      ss.rpc 'game.new', (ready) =>
        if ready
          $(this).fadeOut();
        else
          $(this).attr("disabled", true).text('Waiting for player...')
          $(this).unbind('click')

ss.event.on 'yourTurn', (game) ->
  console.log "Your turn in game #{game.id}"
  console.log game

  $('#turn-title')
    .addClass('your-turn')
    .removeClass('opponent-turn')
    .text('Your turn')

  updateTurnInterval(game)

ss.event.on 'notYourTurn', (game) ->
  console.log "Not your turn in game #{game.id}"
  console.log game

  $('#turn-title')
    .removeClass('your-turn')
    .addClass('opponent-turn')
    .text("Opponent's turn")

  updateTurnInterval(game)

ss.event.on 'stats', (stats) ->
  $('#games-in-progress').text(stats.inProgress)
  $('#games-played').text(stats.played)
  $('#marijuana-found').text(stats.found)

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