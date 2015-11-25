path = require 'path'
{BufferedProcess} = require 'atom'
InputDialog = require '@aki77/atom-input-dialog'

capitalize = (str)-> str[0].toUpperCase() + str[1..].toLowerCase()

module.exports =
class Dictionary

  destroy: =>
    @closeResult()

  search: =>
    editor = atom.workspace.getActiveTextEditor()
    return @open() unless editor
    text = editor.getSelectedText()
    text = editor.getWordUnderCursor() unless text.length > 0
    return @open() unless text.length > 0

    @runCommand(text)

  open: =>
    dialog = new InputDialog
      callback: @runCommand
      prompt: 'Enter a word'
      elementClass: 'dict-input'
    dialog.attach()

  runCommand: (text) =>
    editor = atom.workspace.buildTextEditor(mini: false, softWrapped: true)
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
