timeInterval = null

## Helper functions ##

epoch = ->
  parseInt(+new Date / 1000)
pad2 = (number) ->
  (if number < 10 then '0' else '') + parseInt(number)
sec2minsec = (remaining) ->
  "#{pad2(remaining / 60)}:#{pad2(remaining % 60)}"

ss.server.on 'ready', ->
  jQuery ->
    $game_time = $('#game-time')
    $turn_time = $('#turn-time')

    updateInterval = (game) ->
      updateLabels = ->
        remainingGlobal = game.endEpoch - epoch()
        remainingTurn = game.endTurn - epoch()
        $game_time.text(sec2minsec(remainingGlobal))
        $turn_time.text(sec2minsec(remainingTurn))

      clearInterval timeInterval if timeInterval
      timeInterval = setInterval updateLabels, 1000
      updateLabels()

    ## Update the interval as much as possible ##

    ss.event.on 'newGame', (game) ->
      updateInterval(game)
    ss.event.on 'updatedGame', (playerId, game) ->
      updateInterval(game)
    ss.event.on 'endGame', (playerId, game) ->
      updateInterval(game)
    ss.event.on 'yourTurn', (game) ->
      updateInterval(game)
    ss.event.on 'notYourTurn', (game) ->
      updateInterval(game)