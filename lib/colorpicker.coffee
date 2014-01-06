{$} = require 'atom'
fs = require 'fs'
os = require 'os'
path = require 'path'
spawn = require('child_process').spawn
ColorRegex = require './color_regex'
BIN_DIR = path.join(__dirname, "..", "bin")

module.exports =
  activate: ->
    atom.workspaceView.command 'colorpicker:toggle', '.editor:not(.mini)', =>
      activePane = atom.workspaceView.getActivePane()
      @editor = activePane.activeItem
      return unless @editor.getGrammar().scopeName is 'source.css'
      return unless @editor.getSelectedBufferRange().isEmpty()
      cursor = @editor.getCursor()
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
    fs.exists colorpickerPath, (exists) =>
      unless exists
        console.error "No colorpicker available for #{platform}"
        return
      fs.stat colorpickerPath, (err, stats) =>
        throw err if err
        executable = !!(1 & parseInt((stats.mode & parseInt("777", 8)).toString(8)[0]))
        fs.chmodSync(colorpicker, '755') unless executable

        args = ["-startColor", color] if color
        @color = null
        colorpicker = spawn colorpickerPath, args

        colorpicker.stdout.on 'data', (data) =>
          @color = String(data)

        colorpicker.on 'close', (code) =>
          @replaceSelectedTextWithMatch(@color) if code == 0 && @color?

  replaceSelectedTextWithMatch: (match) ->
    @editor.selectWord()
    selection = @editor.getSelection()
    startPosition = selection.getBufferRange().start
    buffer = @editor.getBuffer()

    selection.deleteSelectedText()
    cursorPosition = @editor.getCursorBufferPosition()
    @editor.insertText(match)
