Board = require '/board'

ss.server.on 'ready', ->
  jQuery ->
    $board = $('#board')

    ## New game ##

    ss.event.on 'newGame', (player, game) ->
      # Setup new board
      board = new Board game.id, game.width, game.height
      console.log game
      for x in [0..(game.width-1)]
        for y in [0..(game.height-1)]
          board.tiles[x][y].set game.state[x][y]
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

    ## End game ##

    ss.event.on 'endGame', (player, game) ->
      # Setup final board # TODO: Fix this shit
      board = new Board game.id, game.width, game.height
      for x in [0..(game.width-1)]
        for y in [0..(game.height-1)]
          board.tiles[x][y].set game.state[x][y]
      $board.html ''
      board.appendTo $board
