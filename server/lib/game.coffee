GameModel = require '../models/game'

module.exports = class Game extends GameModel
  start: (api) ->
    @sendAll('newGame', api)
    @setGlobalTimer(api)
    @resetTurnTimer(api)
    this

  end: (api) ->
    api.room.removeGame(this, api)
    clearTimeout @globalTimeout if @globalTimeout
    clearTimeout @turnTimeout if @turnTimeout
    @state = @board
    @sendAll('endGame', api)

  setGlobalTimer: (api) ->
    @endGame = +new Date + @gameDuration * 1000
    @globalTimeout = setTimeout =>
      @end(api)
    , @gameDuration * 1000

  resetTurnTimer: (api) ->
    @endTurn = +new Date + @turnDuration * 1000
    clearTimeout @turnTimeout if @turnTimeout
    @turnTimeout = setTimeout =>
      @newTurn(api)
    , @turnDuration * 1000
    @sendAll('updatedGame', api)

  click: (player, x, y, api) ->
    # Check player turn
    if @players[@turn].session != player.session
      return false

    # Check click bounds
    if not (0 <= x < @width) or not (0 <= y < @height)
      return false

    # Check if tile is uncoverable
    if @state[x][y] != false
      return false

    @uncover(x, y)

    if @state[x][y] < 0
      api.stats.found += 1
      api.stats.save()

      @scores[@turn] += 1
      @resetTurnTimer(api)

      # Check if game finished
      totalScore = @scores.reduce (t, s) -> t + s
      @end(api) if totalScore == @mines
    else
      @newTurn(api)

  newTurn: (api) ->
    @turn = (@turn + 1) % @players.length
    @resetTurnTimer(api)

  sendAll: (event, api) ->
    for player, index in @players
      api.publish.socketId player.socket, event, index, @clean()