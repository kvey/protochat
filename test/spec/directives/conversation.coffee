'use strict'

describe 'Directive: conversation', () ->
  beforeEach module 'protochatApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<conversation></conversation>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the conversation directive'
