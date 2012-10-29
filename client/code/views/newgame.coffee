NEW_GAME_TEXT = 'New game'
JOIN_GAME_TEXT = 'Join waiting player'
WAITING_GAME_TEXT = 'Waiting for player...'

ss.server.on 'ready', ->
  jQuery ->
    $newGame = $('#newGame')

    ## New/waiting message ##

    newGameInterval = null
    ss.event.on 'waiting', (waiting) ->
      if waiting
        $newGame.text(JOIN_GAME_TEXT)
        # Set success/alert cycle
        newGameInterval = setInterval ->
          $newGame
            .toggleClass('success')
            .toggleClass('alert')
        , 1000
      else
        $newGame.text(NEW_GAME_TEXT)
        # Remove success/alert cycle
        clearInterval newGameInterval
        $newGame
          .removeClass('alert')
          .addClass('success')

    ## New Game click handler ##

    newGameClickHandler = ->
      ss.rpc 'server.new', (ready) =>
        if not ready
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
        .text(NEW_GAME_TEXT)
        .unbind('click')

    ## Enable button on game end ##

    ss.event.on 'endGame', (playerId, game) ->
      $newGame
        .fadeIn()
        .attr('disabled', false)
        .click(newGameClickHandler)