timestamp = ->
  d = new Date()
  d.getHours() + ':' + pad2(d.getMinutes()) + ':' + pad2(d.getSeconds())

pad2 = (number) ->
  (if number < 10 then '0' else '') + number

exports.actions = (req, res, ss) ->
  req.use('session')
  req.use('authentication.check')

  get: ->
    ss.db.collection 'messages', (err, col) ->
      col.find().toArray (err, items) ->
        res items

  send: (message) ->
    ss.db.collection 'messages', (err, col) ->
      col.insert
        nick: req.session.userId
        message: message
        time: timestamp()

    ss.publish.all 'newMessage', req.session.userId, message
    res true
