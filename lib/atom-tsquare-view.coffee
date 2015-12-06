{View} = require 'space-pen'

module.exports =
class AtomTsquareView extends View
  initialize: ({@uri}) ->
    
  @content: ->
    @div =>
      @h1 "Hello Atom!"

  getURI: -> @uri
  getTitle: -> '3D View'

  # Tear down any state and detach
  destroy: ->
    @element.remove()
