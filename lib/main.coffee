{CompositeDisposable} = require 'atom'
Dictionary = require './dictionary'

module.exports =
  subscriptions: null

  config:
    direction:
      type: 'string'
      default: 'down'

  activate: (state) ->
    unless process.platform is 'darwin'
      atom.notifications.addWarning('OSX Only!')
      return

    @dictionary = new Dictionary
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-text-editor',
      'dict:search': @dictionary.search
      'dict:input': @dictionary.open

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
    @dictionary.destroy()
    @dictionary = null
