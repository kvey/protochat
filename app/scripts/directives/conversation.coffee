'use strict'

angular.module('protochatApp')
  .directive('convoChild', () ->
    scope: {
      convoTitle: "="
      convoInbound: "="
    }
    replace: true
    templateUrl: "/views/conversation.html"
    link : (scope, element, attrs) ->
    controller: ['$scope', '$element', '$attrs', '$rootScope', (($scope, $element, $attrs, $rootScope) ->
      $scope.convoInboundList = []
      $scope.convoMessages    = []
      $scope.convoActiveUsers = []
      $scope.convoOutbound    = []

      if $rootScope.user and $rootScope.user.email
        username = $rootScope.user.email
      else
        username = "anon"

      allChatRef             = new Firebase("https://protochat.firebaseio.com/convo")
      conversationRef        = allChatRef.child('outbound').child($scope.convoTitle)
      usersInConversationRef = conversationRef.child('activeUsers')
      conversationRef.child('inbound').push($scope.convoInbound) if $scope.convoInbound

      # add self to active users within a conversation
      usersInConversationRef.child(username).set({
        name: username
        lastAction: (new Date()).getTime()
      })
      # if this isn't a conversation for your user, add sub conversation as name
      unless username is $scope.convoTitle
        conversationRef.child('outbound').child(username).set(username)

      # binding values to firebase references
      conversationRef.child('inbound').on 'child_added', (data)     -> $scope.convoInboundList.push(data.val())
      conversationRef.child('outbound').on 'child_added', (data)    ->  $scope.convoOutbound.push(data.val())
      conversationRef.child('activeusers').on 'child_added', (data) ->  $scope.convoActiveUsers.push(data.val())
      conversationRef.child('messages').on 'child_added', (data)    ->  $scope.convoMessages.push(data.val())

      # TODO: see who is currently typing
      # TODO: have offline messages
      # TODO: fix a conversation in place
      # TODO: silence a conversation
      # TODO: see some degree of who is talking to who
      # TODO: see some degree of who is responding to what


      # send to all children
      $scope.broadcastMessage = () ->
        conversationRef.child('messages').push({
          body: $scope.outMessage
          fromUser: username
          time: (new Date()).getTime()
        })
        for out in $scope.convoOutbound
          console.log("out: #{out}")
          allChatRef.child(out).child('messages').push({
            body: $scope.outMessage
            fromUser: username
            time: (new Date()).getTime()
          })
        usersInConversationRef.child(username).set({
          name: username
          lastAction: (new Date()).getTime()
        })

      # send to an individual
      $scope.sendMessage = () ->
        conversationRef.child('messages').push({
          body: $scope.outMessage
          fromUser: username
          fromConvo: $scope.convoTitle
          time: (new Date()).getTime()
        })
        usersInConversationRef.child(username).set({
          name: username
          lastAction: (new Date()).getTime()
        })

    )]
  )
