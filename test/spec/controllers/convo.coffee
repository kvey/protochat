'use strict'

describe 'Controller: ConvoCtrl', () ->

  # load the controller's module
  beforeEach module 'protochatApp'

  ConvoCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ConvoCtrl = $controller 'ConvoCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
