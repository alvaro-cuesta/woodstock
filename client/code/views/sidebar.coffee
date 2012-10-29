YOUR_TURN_TEXT = 'Your turn'
OPPONENT_TURN_TEXT = "Opponent's turn"

WIN_TEXT = 'You won!'
LOSE_TEXT = 'You lost...'
TIE_TEXT = 'Tied!'

Board = require '/board'

ss.server.on 'ready', ->
  jQuery ->
    $turn_title = $('#turn-title')
    $player_points = $('#player-points')
    $opponent_points = $('#oponent-points')

    ## New game ##

    ss.event.on 'newGame', (game) ->
      $turn_title
        .removeClass('win')
        .removeClass('lose')
        .removeClass('tie')

    ## Updated game ##

    ss.event.on 'updatedGame', (player, game) ->
      # Update score labels
      $player_points.text game.scores[player]
      $opponent_points.text game.scores[(player + 1) % 2]

      # Turn label
      if player == game.turn
        $turn_title
          .addClass('your-turn')
          .removeClass('opponent-turn')
          .text(YOUR_TURN_TEXT)
      else
        $turn_title
          .removeClass('your-turn')
          .addClass('opponent-turn')
          .text(OPPONENT_TURN_TEXT)

    ## End game ##

    ss.event.on 'endGame', (player, game) ->
      $turn_title
        .removeClass('your-turn')
        .removeClass('opponent-turn')

      myScore = game.scores[player]
      opponentScore = game.scores[(player+1) % 2]
      if myScore > opponentScore
        $turn_title
          .addClass('win')
          .removeClass('lose')
          .removeClass('tie')
          .text(WIN_TEXT)
      else if opponentScore > myScore
        $turn_title
          .removeClass('win')
          .addClass('lose')
          .removeClass('tie')
          .text(LOSE_TEXT)
      else
        $turn_title
          .removeClass('win')
          .removeClass('lose')
          .addClass('tie')
          .text(TIE_TEXT)