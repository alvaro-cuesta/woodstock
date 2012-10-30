module.exports = class Room
  constructor: (@GameModel, @options, @capacity, @api) ->
    @waiting = []
    @games = []

  addPlayer: (player) ->
    if player.session in (x.session for x in @waiting)
      return false

    @waiting.push player if @waiting.length < @capacity

    if @waiting.length == @capacity
      # Find a free game id and create game
      gameId = 0
      gameId++ while @games[gameId]

      @games[gameId] = new @GameModel(gameId, @waiting, @options).start(@api)

      @waiting = []

      # Update game stats
      @api.stats.played += 1
      @api.stats.inProgress += 1
      @api.stats.save()

    @publishWaiting()
    return true

  removeGame: (game) ->
    delete @games[game.id]
    @api.stats.inProgress -= 1
    @api.stats.inProgress = 0 if @api.stats.inProgress < 0
    @api.stats.save()

  publishWaiting: ->
    @api.publish.all 'waiting', (x.nick for x in @waiting)
