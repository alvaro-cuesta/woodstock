registrations = []

exports.actions = (req, res, ss) ->
  req.use('session')

  login: (nick, password) ->
    console.log password

    if not nick or nick.length <= 0
      res "Invalid nick"
      return

    if not password or password.length <= 0
      res "Invalid password"
      return

    if registrations[nick]
      if password != registrations[nick]
        res "Invalid username or password"
        return
    else
      registrations[nick] = password

    req.session.setUserId nick
    ss.publish.user req.session.userId, 'loggedIn', nick

    res false

  getNick: ->
    ss.publish.user req.session.userId, 'loggedIn', req.session.userId
