SAMPLES = 5
SAMPLE_INTERVAL = 3000

deltas = []

module.exports.delta = null

module.exports.sync = ->
  sync = ->
    clientTime = +new Date
    ss.rpc 'server.ping', (serverTime) ->
      currentTime = +new Date
      timeDelta = serverTime - currentTime + parseInt ((currentTime - clientTime)/2)

      deltas.unshift(timeDelta)
      deltas.sort (a, b) -> a-b

      module.exports.delta = deltas[parseInt(deltas.length/2)]
        
      clearInterval syncInterval if deltas.length == SAMPLES
  syncInterval = setInterval sync, SAMPLE_INTERVAL
  sync()
