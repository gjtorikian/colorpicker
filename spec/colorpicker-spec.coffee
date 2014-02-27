{WorkspaceView} = require 'atom'
Colorpicker = require '../lib/colorpicker'
child_process = require 'child_process'
path = require 'path'

describe "Colorpicker", ->
  FIXTURES_DIR = path.join(__dirname, 'fixtures')
  [buffer, editor, editSession, workspaceView] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    workspaceView = atom.workspaceView
    atom.packages.activatePackage('colorpicker', immediate: true)
    atom.packages.activatePackage('language-css', sync: true)
    atom.workspaceView.attachToDom()

  describe "launching the colorpicker", ->
    beforeEach ->
      spyOn(Colorpicker, 'showColorpickerDialog')

    describe "when there is no valid grammer", ->
      it "does not launch the colorpicker", ->
        workspaceView.openSync(path.join(FIXTURES_DIR, 'not-valid.md'))
        editorView = workspaceView.getActiveView()
        editor = editorView.getEditor()
        editor.setCursorBufferPosition([1, 25])

        editorView.trigger 'colorpicker:toggle'

        waits(500)
        runs ->
          expect(Colorpicker.showColorpickerDialog).not.toHaveBeenCalled()

    describe "when there is a valid CSS grammer", ->
      it "launches the colorpicker", ->
        workspaceView.openSync(path.join(FIXTURES_DIR, 'css', 'hex-long.css'))
        editorView = workspaceView.getActiveView()
        editor = editorView.getEditor()

        editor.setCursorBufferPosition([1, 25])

        editorView.trigger 'colorpicker:toggle'

        # let it do the fs calls
        waits(500)

        runs ->
          expect(Colorpicker.showColorpickerDialog).toHaveBeenCalledWith(path.join(Colorpicker.getBinDir(), "darwin-colorpicker"), [{ color : '#ffffff', start : 20, end : 28 }] )
