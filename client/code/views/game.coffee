YOUR_TURN_TEXT = 'Your turn'
OPPONENT_TURN_TEXT = "Opponent's turn"

WIN_TEXT = 'You won!'
LOSE_TEXT = 'You lost...'
TIE_TEXT = 'Tied!'

Board = require '/board'

ss.server.on 'ready', ->
  jQuery ->
    $board = $('#board')
    $turn_title = $('#turn-title')
    $player_points = $('#player-points')
    $opponent_points = $('#oponent-points')

    ## New game ##

    ss.event.on 'newGame', (game) ->
      # Setup new board
      board = new Board game.id, game.width, game.height
      $board.html ''
      board.appendTo $board

    ## Updated game ##

    ss.event.on 'updatedGame', (player, game) ->
      # Setup updated board # TODO: Fix this shit
      board = new Board game.id, game.width, game.height
      for x in [0..(game.width-1)]
        for y in [0..(game.height-1)]
          board.tiles[x][y].set game.state[x][y]
      $board.html ''
      board.appendTo $board

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
      # Setup final board # TODO: Fix this shit
      board = new Board game.id, game.width, game.height
      for x in [0..(game.width-1)]
        for y in [0..(game.height-1)]
          board.tiles[x][y].set game.state[x][y]
      $board.html ''
      board.appendTo $board

      # Update scores
      myScore = game.scores[player]
      opponentScore = game.scores[(player + 1) % 2]
      $player_points.text myScore
      $opponent_points.text opponentScore

      # Update turn label (win/lose/tie)
      if myScore > opponentScore
        $turn_title
          .addClass('won')
          .removeClass('lost')
          .removeClass('tied')
          .text(WIN_TEXT)
      else if opponentScore > myScore
        $turn_title
          .removeClass('won')
          .addClass('lost')
          .removeClass('tied')
          .text(LOSE_TEXT)
      else
        $turn_title
          .removeClass('won')
          .removeClass('lost')
          .addClass('tied')
          .text(TIE_TEXT)