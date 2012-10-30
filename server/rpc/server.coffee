exports.actions = (req, res, ss) ->
  ping: (time) ->
    res +new Date

  status: ->
    ss.publish.socketId req.socketId, 'stats', ss.stats.clean()
    ss.publish.socketId req.socketId, 'waiting', (x.nick for x in ss.room.waiting)
