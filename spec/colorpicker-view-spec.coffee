ColorpickerView = require '../lib/colorpicker-view'
{WorkspaceView} = require 'atom'

describe "ColorpickerView", ->
  colorpicker = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    colorpicker = atom.packages.activatePackage('colorpicker', immediate: true)

  describe "when the colorpicker:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.colorpicker')).not.toExist()
      atom.workspaceView.trigger 'colorpicker:toggle'
      expect(atom.workspaceView.find('.colorpicker')).toExist()
      atom.workspaceView.trigger 'colorpicker:toggle'
      expect(atom.workspaceView.find('.colorpicker')).not.toExist()
