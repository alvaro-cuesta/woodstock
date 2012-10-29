Gradation = require '/gradation'
Cloud = require '/cloud'
Canvas = require '/canvas'

NUM_CLOUDS = 100
MSECS_PER_STEP = 30
DEFAULT_OPACITY_SPEED = 0.005 

canvas = null
gradation = null
clouds = []

graphicLoop = null

ss.server.on 'ready', ->
  jQuery ->
    canvas = new Canvas $('#c')
    gradation = new Gradation canvas
    canvas.draw()
    gradation.draw()

module.exports.start = ->
  for i in [1..NUM_CLOUDS]
    clouds.push new Cloud canvas
  for i in clouds
    i.opacitySpeed DEFAULT_OPACITY_SPEED

  graphicLoop = setInterval ->
    canvas.update()
    canvas.draw()
    for i in clouds
      i.update()
      i.draw()
    gradation.update()
    gradation.draw()
  , MSECS_PER_STEP

module.exports.stop = ->
  if graphicLoop
    clearInterval graphicLoop
  graphicLoop = null
  canvas.draw()
  gradation.draw()