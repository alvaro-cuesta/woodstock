Server = require '../rpc/server'
GameModel = require '../models/game'

epoch = ->
  parseInt(+new Date / 1000)

module.exports = class Game extends GameModel
  sendAll: (event, ss) ->
    for player, index in @players
      ss.publish.socketId player.socket, event, index, @clean()

  setGlobalTimer: (ss) ->
    @endGame = epoch() + @gameDuration
    @globalTimeout = setTimeout =>
      @end(ss)
    , @gameDuration * 1000

  resetTurnTimer: (ss) ->
    @endTurn = epoch() + @turnDuration
    clearTimeout @turnTimeout if @turnTimeout
    @turnTimeout = setTimeout =>
      @newTurn(ss)
    , @turnDuration * 1000
    @sendAll('updatedGame', ss)

  newTurn: (ss) ->
    @turn = (@turn + 1) % @players.length
    @resetTurnTimer(ss)

  end: (ss) ->
    clearTimeout @globalTimeout if @globalTimeout
    clearTimeout @turnTimeout if @turnTimeout
    Server.removeGame(this, ss)
          
    @sendAll('endGame', ss)
