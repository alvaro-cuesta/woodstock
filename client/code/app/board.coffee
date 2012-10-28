Tile = require '/tile'

module.exports = (id, width, height) ->
  tiles: for x in [0..(width-1)]
    for y in [0..(height-1)]
      tile = new Tile
      do (tile, x, y) ->
        tile.click ->
          ss.rpc 'game.click', id, x, y
      tile

  appendTo: ($board) ->
    for y in [0..(height-1)]
      $board.append this.tiles[x][y] for x in [0..(width-1)]
      $board.append '<br />'
