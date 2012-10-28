module.exports = ->
  $tile = $ '<div class="tile">'
  $tile.number = null

  $tile.set = (number) ->
    $tile.number = number
    if number < 0
      $tile.addClass 'maria'
    else if num > 0 
      $tile.addClass "n#{number}"
      $tile.html number

    $tile.addClass 'pressed'
    return true

  return $tile
