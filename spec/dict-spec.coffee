Dictionary = require '../lib/dictionary'
# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Dict", ->
  [workspaceElement, activationPromise, editor, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)
    atom.config.set('dict.direction', 'down')

    spyOn(Dictionary::, 'buildProcess').andCallFake (text, _editor) ->
      _editor.insertText("result #{text}")
      @showResult(_editor, 0)

    waitsForPromise ->
      atom.workspace.open().then (_editor) ->
        editor = _editor
        editorElement = atom.views.getView(editor)
        editor.setText('test')

    runs ->
      activationPromise = atom.packages.activatePackage('dict')
      atom.packages.loadPackage('dict').loadGrammarsSync()

  describe 'activate', ->
    it 'dict:search', ->
      atom.commands.dispatch(editorElement, 'dict:search')
      waitsForPromise -> activationPromise

      runs ->
        _editor = atom.workspace.getActivePaneItem()
        expect(_editor.getTitle()).toEqual('Atom Dictionary')
        expect(_editor.getText()).toEqual('result test')

    it 'dict:input', ->
      expect(workspaceElement.querySelector('.dict-input')).not.toExist()
      atom.commands.dispatch(editorElement, 'dict:input')
      waitsForPromise -> activationPromise

      runs ->
        inputElement = workspaceElement.querySelector('.dict-input')
        expect(inputElement).toExist()
        expect(inputElement).toBeVisible()
