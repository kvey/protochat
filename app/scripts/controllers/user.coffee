'use strict'

angular.module('protochatApp')
  .controller 'UserCtrl', ($scope, $rootScope) ->
    $rootScope.user = ""

    fbref = new Firebase("https://protochat.firebaseio.com")
    authClient = new FirebaseAuthClient fbref, (error, user) ->
      if error
        console.log(error)
      else if user
        $rootScope.user = user
      else
        $rootScope.user = "not logged in"


    $scope.register = ->
      authClient.createUser $scope.authEmail, $scope.authPass, (error, user) ->
        console.log "user created #{user}" unless error

    $scope.login = -> authClient.login 'password',
        email    : $scope.authEmail
        password : $scope.authPass

    $scope.logout = -> authClient.logout()
