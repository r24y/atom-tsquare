AtomTsquareView = require './atom-tsquare-view'
{CompositeDisposable} = require 'atom'

URI_3DVIEW = 'tsquare://3d'
URI_3DVIEW_WITH_FILE = new RegExp "#{URI_3DVIEW}\\?file=(.*)"

console.log URI_3DVIEW

module.exports = AtomTsquare =
  subscriptions: null
  views: null

  activate: (state) ->
    @views = {}

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-tsquare:open': => @open()
    atom.workspace.addOpener (uri) => @opener uri

  deactivate: ->
    @subscriptions.dispose()
    Object.keys(@views).forEach v => @views[v].destroy()
    @views = {}

  opener: (uri) ->
    m = URI_3DVIEW_WITH_FILE.exec uri
    console.log URI_3DVIEW_WITH_FILE, uri, m
    return unless m
    [_, fileUri] = m
    editor = atom.workspace.paneForURI(fileUri)?.itemForURI(fileUri)
    unless @views[fileUri]
      @views[fileUri] = new AtomTsquareView uri: fileUri, cadSource: editor?.getText()
    @views[fileUri]

  open: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor
    source = editor.getText()
    path = editor.getPath()
    atom.workspace.open "#{URI_3DVIEW}?file=#{path}"
