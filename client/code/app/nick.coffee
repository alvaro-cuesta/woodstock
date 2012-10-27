# NICK ACCEPTED EVENT
ss.event.on 'loggedIn', (nick) ->
  if nick
    $('#loginForm').show().slideUp()
  else
    $('#loginForm').hide().slideDown()

# FORM
$('#nick').focus  ->
  nick = $('#nick').val()
  if nick == 'Nick'
    $('#nick').val('')

$('#nick').blur  ->
  nick = $('#nick').val()
  if nick == ''
    $('#nick').val('Nick')

$('#pass').focus  ->
  pass = $('#pass').val()
  if pass == 'Pass'
    $('#pass').val('')

$('#pass').blur  ->
  pass = $('#pass').val()
  if pass == ''
    $('#pass').val('Pass')

$('#loginForm').on 'submit', ->
  nick = $('#nick').val()
  pass = $('#pass').val()

  if nick and nick.length > 0 and pass and pass.length > 0
     ss.rpc 'user.login', nick, pass, (err) ->
      console.log 'what'
      if err
        html = ss.tmpl['alert'].render
          strong: 'Error!'
          message: err
        $(html).addClass('alert-error').hide().appendTo('#login').slideDown()
      else
        $('#loginForm').show().slideUp()
