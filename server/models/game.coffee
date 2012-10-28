# TODO:
#  Controlar mejor tiempos (setTimeout no es preciso)

rand = (min, max) ->
  min + Math.floor Math.random() * max

## Base Game model (and a bit of controller hehe)
class Game
  constructor: (@width, @height, @mines, @gameDuration, @turnDuration, @players, @turnCallback, @endCallback) ->
    # <0   - mine
    # >=0  - # of surrounding mines
    @board = ((0 for y in [0..(@height-1)]) for x in [0..(@width-1)])
    # false   - covered
    @state = ((false for y in [0..(@height-1)]) for x in [0..(@width-1)])

    # Drop random mines
    for k in [1..@mines]
      loop  # Search for an empty spot
        x = rand(0, @width)
        y = rand(0, @height)
        break if @board[x][y] >= 0

      # Mark adjacency matrix
      for i in [-1..1]
        for j in [-1..1]
          if (0 <= x+i < @width) and (0 <= y+j < @height)
            @board[x+i][y+j] += 1
      @board[x][y] = -mines  # ...and mark the spot as a mine (<0)

    @turn = rand(@players.length) # Random turn

    # Set end-game timeout
    @globalTimeout = setTimeout =>
      clearTimeout @turnTimeout
      @endCallback this
    , @gameDuration * 1000

    # Set turn timeout
    @resetTurnTimeout()

    # Set player scores
    @scores = (0 for x in players)

  uncover: (x, y) ->
    @state[x][y] = @board[x][y]

    if @board[x][y] == 0  # No adjacencies, do cascade
      for i in [-1..1]
        for j in [-1..1]
          if (0 <= x+i < @width) and (0 <= y+j < @height) and (@state[x+i][y+j] == false)
            @uncover x+i, y+j

  resetTurnTimeout: ->
    clearTimeout @turnTimeout
    @turnTimeout = setTimeout =>
      clearTimeout @globalTimeout
      @turnCallback this
    , @turnDuration * 1000

module.exports = Game