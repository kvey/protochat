'use strict'

angular.module('protochatApp')
  .controller 'ConvoCtrl', ['$scope', '$routeParams', '$rootScope', ($scope, $routeParams, $rootScope) ->
    # scope vars
    $scope.convoTitle       = $routeParams.conversation
    $scope.convoMessages    = []
    $scope.convoActiveUsers = []
    $scope.convoInbound     = []
    $scope.convoOutbound    = []

    allChatRef = new Firebase("https://protochat.firebaseio.com/convo")
    convoRef   = allChatRef.child('outbound').child($scope.convoTitle)

    convoRef.child('inbound').on 'child_added', (data)     -> $scope.convoInbound.push(data.val())
    convoRef.child('activeusers').on 'child_added', (data) -> $scope.convoActiveUsers.push(data.val())
    convoRef.child('messages').on 'child_added', (data)    -> $scope.convoMessages.push(data.val())
    convoRef.child('outbound').on 'child_added', (data)    -> $scope.convoOutbound.push(data.val())

    if $rootScope.user and $rootScope.user.email
      username = $rootScope.user.email
    else
      username = "anon"

    usersInConversationRef = convoRef.child('activeUsers')

    # add self to active users within a conversation
    usersInConversationRef.child(username).set({
      name: username
      lastAction: (new Date()).getTime()
    })

    # if this isn't a conversation for your user, add sub conversation as name - this is for testing mostly
    unless username is $scope.convoTitle
      convoRef.child('outbound').child(username).set(username)

    # need to be able to see who is currently typing
    # need to be able to have offline messages
    # need to be able to fix a conversation in place
    # need to be able to silence a conversation
    # need to be able to see some degree of who is talking to who
    # need to be able to see some degree of who is responding to what

    $scope.broadcastMessage = () ->
      #this should follow all sub conversations and push to them
      convoRef.child('messages').push({
        body: $scope.msgBroadcast
        fromUser: username
        time: (new Date()).getTime()
      })
      for out in $scope.convoOutbound
        console.log(out)
        allChatRef.child('outbound').child(out).child('messages').push({
          body: $scope.msgBroadcast
          fromUser: username
          fromConvo: $scope.convoTitle
          time: (new Date()).getTime()
        })
      usersInConversationRef.child(username).set({
        name: username
        lastAction: (new Date()).getTime()
      })

    $scope.setUsername = (newUsername) ->
      convosRef.child('activeUsers').child(newUsername).child("name").set(newUsername)

    $scope.goToConversation = (name) ->
      window.location.hash = "/#{name}"


    return this

  ]
