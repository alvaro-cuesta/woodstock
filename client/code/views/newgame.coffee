NEW_GAME_TEXT = 'New game'
JOIN_GAME_TEXT = 'Join waiting player'
WAITING_GAME_TEXT = 'Waiting for player...'

ss.server.on 'ready', ->
  jQuery ->
    $newGame = $('#newGame')

    ## New/waiting message ##

    newGameInterval = null
    ss.event.on 'waiting', (waiting) ->
      if waiting.length
        if $newGame.text() != WAITING_GAME_TEXT
          $newGame.text(JOIN_GAME_TEXT)
        newGameInterval = setInterval ->
          $newGame
            .toggleClass('success')
            .toggleClass('alert')
        , 1000
      else
        clearInterval newGameInterval if newGameInterval
        newGameInterval = null
        $newGame
          .removeClass('alert')
          .addClass('success')
          .text(NEW_GAME_TEXT)

    ## New Game click handler ##

    newGameClickHandler = ->
      ss.rpc 'game.new', (success) =>
        if success
          $(this)
            .attr('disabled', true)
            .text(WAITING_GAME_TEXT)
            .unbind('click')
    $newGame.click(newGameClickHandler)

    ## Disable button on game start ##

    ss.event.on 'newGame', (playerId, game) ->
      $newGame
        .fadeOut()
        .attr('disabled', true)
        .unbind('click')

    ## Enable button on game end ##

    ss.event.on 'endGame', (playerId, game) ->
      $newGame
        .fadeIn()
        .attr('disabled', false)
        .text(NEW_GAME_TEXT)
        .click(newGameClickHandler)