window.ss = require('socketstream')

ss.server.on 'disconnect', ->
  # TODO: ALERT
  # TODO: DISABLE EVERYTHING
  console.log('Connection down :-(')

ss.server.on 'reconnect', ->
  # TODO: ENABLE EVERYTHING
  ss.rpc 'user.getNick'
  console.log('Connection back up :-)')

ss.server.on 'ready', ->
  jQuery ->
    require '/nick'
    require '/chat'
    require '/game'
    ss.rpc 'user.getNick'
