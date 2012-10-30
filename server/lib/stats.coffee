fs = require 'fs'
fs.existsSync = fs.existsSync || require('path').existsSync

module.exports = class Stats
  constructor: (@file, @api) ->
    if fs.existsSync @file
      data = JSON.parse(fs.readFileSync @file, 'utf8')
      @played = data.played
      @found = data.found
    else
      console.log "Stats file #{@file} not found. Resetting."
      @played = 0
      @found = 0

    @inProgress = 0

  save: ->
    fs.writeFile @file, JSON.stringify(@clean()), (err) ->
      if err
        console.log 'Error serializing stats to @{file}: @{err}'
    @api.publish.all 'stats', @clean()

  clean: ->
    played: @played
    inProgress: @inProgress
    found: @found
