path = require 'path'
{BufferedProcess, TextEditor} = require 'atom'
{TextEditorView}  = require 'atom-space-pen-views'
InputView = require './input-view'

capitalize = (str)-> str[0].toUpperCase() + str[1..].toLowerCase()

module.exports =
class Dictionary

  destroy: =>
    @closeResult()
    @inputView = null

  search: =>
    editor = atom.workspace.getActiveTextEditor()
    return @open() unless editor
    text = editor.getSelectedText()
    text = editor.getWordUnderCursor() unless text.length > 0
    return @open() unless text.length > 0

    @runCommand(text)

  open: =>
    @inputView ?= new InputView(callback: @runCommand)
    @inputView.open()

  runCommand: (text) =>
    editor = new TextEditor(mini: false, softWrapped: true)
    editor.getTitle = -> 'Atom Dictionary'
    @buildProcess(text, editor)

  buildProcess: (text, editor) ->
    {command, args} = @getCmdAndArgs(text)
    process = new BufferedProcess({
      command,
      args,
      stdout: (output) -> editor.insertText(output)
      exit: (code) => @showResult(editor, code)
    })

  showResult: (editor, code) ->
    return console.error "exit code #{code}" if code isnt 0

    direction = capitalize(atom.config.get('dict.direction'))
    editor.moveToTop()
    editor.setGrammar(atom.grammars.grammarForScopeName('text.dict'))
    @closeResult()
    @pane = atom.workspace.getActivePane()["split#{direction}"]()
    @pane.addItem(editor)
    editorView = atom.views.getView(editor)
    atom.commands.add(editorView, 'core:cancel', @closeResult)

  closeResult: =>
    @pane?.destroy()
    @pane = null

  getCmdAndArgs: (text) ->
    command = path.resolve(path.join(__dirname, '..', 'bin', 'dictionary'))

    {
      command
      args: [text]
    }
