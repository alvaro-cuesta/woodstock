timestamp = ->
  d = new Date()
  d.getHours() + ':' + pad2(d.getMinutes()) + ':' + pad2(d.getSeconds())

pad2 = (number) ->
  (if number < 10 then '0' else '') + number

# READ MESSAGES ON INIT
jQuery ->
  messages = ss.rpc 'chat.get', (messages) ->
   for message in messages
     html = ss.tmpl['chat-message'].render message
     $(html).hide().appendTo('#chatlog')

# MESSAGE EVENT
ss.event.on 'newMessage', (nick, message) ->
  html = ss.tmpl['chat-message'].render
    nick: nick
    message: message
    time: timestamp

  $(html).hide().appendTo('#chatlog').slideDown()

# NICK ACCEPTED EVENT
ss.event.on 'nick', (nick) ->
  console.log nick
  if nick
    $('#chatForm').slideDown()
  else
    $('#chatForm').slideUp()

# FORM
$('#chatForm').on 'submit', ->
  text = $('#message').val()

  send text, (success) ->
    if success
      $('#message').val('')  # clear text box
    else
      alert('Oops! Unable to send message')

send = (text, cb) ->
  if text and text.length > 0
    ss.rpc 'chat.send', text, cb
  else
    cb false