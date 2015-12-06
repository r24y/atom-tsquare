AtomTsquareView = require './atom-tsquare-view'
{CompositeDisposable} = require 'atom'

URI_3DVIEW = 'tsquare://3d'

console.log URI_3DVIEW

module.exports = AtomTsquare =
  subscriptions: null
  views: null

  activate: (state) ->
    console.log 'activate'
    @views = {}

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-tsquare:open': => @open()
    atom.workspace.addOpener (uri) => @opener uri
    console.log 'activated'

  deactivate: ->
    @subscriptions.dispose()
    Object.keys(@views).forEach v => @views[v].destroy()
    @views = {}

  opener: (uri) ->
    return unless uri.match /^tsquare:\/\//
    unless @views[uri]
      @views[uri] = new AtomTsquareView uri: uri
    @views[uri]

  open: ->
    console.log 'AtomTsquare was opened!'
    atom.workspace.open URI_3DVIEW
