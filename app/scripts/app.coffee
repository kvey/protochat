'use strict'

angular.module('protochatApp', ['firebase'])
  .config(($routeProvider) ->
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      })
      .when('/:conversation', {
        templateUrl: 'views/main.html'
        controller: 'ConvoCtrl'
      })
      .otherwise({
        redirectTo: '/'
      })
  )
