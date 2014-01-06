{WorkspaceView} = require 'atom'
Colorpicker = require '../lib/colorpicker'
child_process = require 'child_process'
path = require 'path'

describe "Colorpicker", ->
  FIXTURES_DIR = path.join(__dirname, 'fixtures')
  [buffer, editor, editSession, workspaceView] = []

  beforeEach ->
    atom.packages.activatePackage('colorpicker', immediate: true)
    atom.workspaceView = new WorkspaceView
    workspaceView = atom.workspaceView

  # TODO: how does spying on launching work?

  # describe "when there is no valid grammer", ->
  #   it "does not launch the colorpicker", ->
  #
  # describe "when there is some valid grammer", ->
  #   it "launches the colorpicker", ->
  #     spawn = spyOn(child_process, 'spawn').andReturn({ stdout: { on: -> }, stderr: { on: -> }, on: -> })
  #
  #     workspaceView.openSync(path.join(FIXTURES_DIR, 'css/short-hex.css'))
  #     editor = workspaceView.getActiveView()
  #     editSession = workspaceView.getActivePaneItem()
  #     editSession.setCursorBufferPosition([1, 22])
  #
  #     editor.trigger keydownEvent('c', shiftKey: true, metaKey: true, target: editor[0])
  #     expect(child_process.spawn).toHaveBeenCalled()
