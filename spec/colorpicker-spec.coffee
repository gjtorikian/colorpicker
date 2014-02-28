{WorkspaceView} = require 'atom'
Colorpicker = require '../lib/colorpicker'
child_process = require 'child_process'
path = require 'path'
os = require 'os'

describe "Colorpicker", ->
  FIXTURES_DIR = path.join(__dirname, 'fixtures')
  [buffer, editor, editSession, workspaceView] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    workspaceView = atom.workspaceView
    atom.packages.activatePackage('colorpicker', immediate: true)
    atom.packages.activatePackage('language-css', sync: true)
    atom.workspaceView.attachToDom()

  setupColorpickerLaunch = (filename, cursorPos) ->
    workspaceView.openSync(path.join(FIXTURES_DIR, filename))
    editorView = workspaceView.getActiveView()
    editor = editorView.getEditor()
    editor.setCursorBufferPosition(cursorPos)
    editorView.trigger 'colorpicker:toggle'

  describe "launching the colorpicker", ->
    beforeEach ->
      spyOn(Colorpicker, 'spawnColorPicker')

    describe "when there is no valid grammer", ->
      it "does not launch the colorpicker", ->
        setupColorpickerLaunch("not-valid.md", [0, 25])

        waits(100)
        runs ->
          expect(Colorpicker.spawnColorPicker).not.toHaveBeenCalled()

    describe "when there is a valid CSS grammer", ->
      it "launches the colorpicker", ->
        setupColorpickerLaunch("css/hex-long.css", [1, 25])

        # let it do the fs calls
        waits(100)
        runs ->
          expect(Colorpicker.spawnColorPicker).toHaveBeenCalledWith(["-startColor", "#ffffff"] )

  describe "colorpicker binary path", ->
    it "should exist", ->
      expect(Colorpicker.colorPickerPath()).toBe path.join(Colorpicker.getBinDir(), "#{os.platform()}-colorpicker")
