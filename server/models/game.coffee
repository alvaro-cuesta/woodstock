rand = (min, max) ->
  min + Math.floor Math.random() * max

module.exports = class GameModel
  constructor: (@id, @players, @width=27, @height=17, @mines=52, @gameDuration=30, @turnDuration=15) ->
    # <0   - mine
    # >=0  - number of surrounding mines
    # false   - covered
    @board = ((0 for y in [0..(@height-1)]) for x in [0..(@width-1)])
    @state = ((false for y in [0..(@height-1)]) for x in [0..(@width-1)])

    # Drop random mines
    for k in [1..@mines]
      # Search for an empty spot
      loop
        x = rand(0, @width)
        y = rand(0, @height)
        break if @board[x][y] >= 0

      # Mark adjacency matrix
      for i in [-1..1]
        for j in [-1..1]
          if (0 <= x+i < @width) and (0 <= y+j < @height)
            @board[x+i][y+j] += 1

      # ...and mark the spot as a mine (<0)
      @board[x][y] = -@mines

    # Random turn
    @turn = rand(0, @players.length)

    # Initialize player scores
    @scores = (0 for x in players)

  uncover: (x, y) ->
    @state[x][y] = @board[x][y]

    if @board[x][y] == 0  # No adjacencies, do cascade
      for i in [-1..1]
        for j in [-1..1]
          if (0 <= x+i < @width) and (0 <= y+j < @height) and (@state[x+i][y+j] == false)
            @uncover x+i, y+j

  clean: ->
    id: @id
    width: @width
    height: @height
    mines: @mines
    gameDuration: @gameDuration
    turnDuration: @turnDuration
    state: @state
    turn: @turn
    scores: @scores
    endGame: @endGame
    endTurn: @endTurn
    players: [player['nick'] for player in @players]
