ss.server.on 'ready', ->
  jQuery ->

    ## Connection status label ##

    ss.server.on 'disconnect', ->
      $('#game-status')
        .removeClass('connected')
        .addClass('not-connected')
        .text('Disconnected')

    ss.server.on 'reconnect', ->
      $('#game-status')
        .addClass('connected')
        .removeClass('not-connected')
        .text('Connected')

    ## Statistic labels ##

    ss.event.on 'stats', (stats) ->
      $('#game-status')
        .addClass('connected')
        .removeClass('not-connected')
        .text('Connected')
      $('#games-in-progress').text(stats.inProgress)
      $('#games-played').text(stats.played)
      $('#marijuana-found').text(stats.found)