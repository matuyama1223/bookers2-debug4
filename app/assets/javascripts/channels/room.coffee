
document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", room: $('#direct_messages').data('room_id')},
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#direct_messages').append data['direct_message']

    speak: (direct_message) ->
      @perform 'speak', direct_message: direct_message

  $('#chat-input').on 'keypress',(event) ->
    if event.ketcode is 13 #enter
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()