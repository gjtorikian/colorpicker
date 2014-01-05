{$} = require 'atom'
fs = require 'fs'
os = require 'os'
path = require 'path'
spawn = require('child_process').spawn
ColorRegex = require './color_regex'
BIN_DIR = path.join(__dirname, "..", "bin")

module.exports =
  activate: ->
    atom.workspaceView.eachEditorView (editor) =>
      return unless editor.attached and editor.getPane()?
      editor.on 'click', (e) =>
        editorView = e.currentTargetView()
        return unless editorView.getGrammar().scopeName is 'source.css'
        return if editorView.getSelectedBufferRange().isEmpty()
        cursor = editorView.getCursor()
        line = cursor.getCurrentBufferLine()
        pos = cursor.getBufferPosition()
        colors = @detectColors(pos, line)
        @toggleColorPicker(pos, line, colors[1]) if colors[1]

  detectColors: (pos, line) ->
    colors = line.match(ColorRegex.isColor)
    return [] if !colors?
    start = end = 0
    col = pos.column
    for color in colors
      start = line.indexOf(color)
      end = start + color.length
      if (col >= start && col <= end)
          return [colors, color]

    return [colors]

  toggleColorPicker: (pos, line, color) ->
    platform = os.platform()
    colorpickerPath = path.join(BIN_DIR, "#{platform}-colorpicker")
    fs.exists colorpickerPath, (exists) ->
      unless exists
        console.error "No colorpicker available for #{platform}"
        return
      fs.stat colorpickerPath, (err, stats) ->
        throw err if err
        executable = !!(1 & parseInt((stats.mode & parseInt("777", 8)).toString(8)[0]))
        fs.chmodSync(colorpicker, '755') unless executable
        args = ["-startColor", color] if color
        colorpicker = spawn colorpickerPath, args

        colorpicker.stdout.on 'data', (data) =>
          @color = data

        colorpicker.on 'close', (code) =>
          if code == 0
            @color
