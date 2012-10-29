stats =
  played: 0
  inProgress: 0
  found: 0

module.exports.sendStats = (ss) ->
  ss.publish.all 'stats', stats

exports.actions = (req, res, ss) ->
  synchronize: ->
    ss.publish.socketId req.socketId, 'stats', stats
    ss.publish.socketId req.socketId, 'waiting', waiting
    res true
