'use strict'

describe 'Controller: ConvoChildCtrl', () ->

  # load the controller's module
  beforeEach module 'protochatApp'

  ConvoChildCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ConvoChildCtrl = $controller 'ConvoChildCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
