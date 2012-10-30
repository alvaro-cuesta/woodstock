time = require '/time'

pad2 = (number) ->
  number = 0 if number < 0
  (if number < 10 then '0' else '') + parseInt(number)
sec2minsec = (remaining) ->
  "#{pad2(remaining / 60)}:#{pad2(remaining % 60)}"

ss.server.on 'ready', ->
  jQuery ->
    $game_time = $('#game-time')
    $turn_time = $('#turn-time')

    timeInterval = null

    updateLabels = (game) ->
      remainingGame = parseInt((game.endGame - new Date - 1 - time.delta) / 1000)
      remainingTurn = parseInt((game.endTurn - new Date - 1 - time.delta) / 1000)
      $game_time.text(sec2minsec(remainingGame))
      $turn_time.text(sec2minsec(remainingTurn))

    ss.event.on 'endGame', (player, game) ->
      clearInterval timeInterval if timeInterval
      updateLabels(game)

    resetInterval = (game) ->
      clearInterval timeInterval if timeInterval
      updateLabels(game)
      timeInterval = setInterval ->
        updateLabels(game)
      , 1000

    ss.event.on 'newGame', (player, game) ->
      resetInterval(game)
    ss.event.on 'updatedGame', (player, game) ->
      resetInterval(game)
