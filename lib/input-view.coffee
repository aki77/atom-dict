{$, TextEditorView, View}  = require 'atom-space-pen-views'

module.exports =
class InputView extends View
  @content: ->
    @div class: 'dict-input', =>
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'message', outlet: 'message'

  initialize: ({@callback}={}) ->
    @panel = atom.workspace.addModalPanel(item: this, visible: false)
    @miniEditor.on 'blur', @close

    atom.commands.add @miniEditor.element, 'core:confirm', @confirm
    atom.commands.add @miniEditor.element, 'core:cancel', @close

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.views.getView(atom.workspace).focus()

  confirm: =>
    text = @miniEditor.getText()
    return unless text.length > 0
    @callback?(text)
    @close()

  toggle: ->
    if @panel.isVisible()
      @close()
    else
      @open()

  close: =>
    return unless @panel.isVisible()

    miniEditorFocused = @miniEditor.hasFocus()
    @miniEditor.setText('')
    @panel.hide()
    @restoreFocus() if miniEditorFocused

  open: ->
    return if @panel.isVisible()

    if editor = atom.workspace.getActiveTextEditor()
      @storeFocusedElement()
      @panel.show()
      @message.text('Enter a word')
      @miniEditor.focus()
