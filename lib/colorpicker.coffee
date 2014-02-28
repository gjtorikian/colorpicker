{$} = require 'atom'
fs = require 'fs'
os = require 'os'
path = require 'path'
spawn = require('child_process').spawn
tinycolor = require "tinycolor2"
color_regex = require('./color_regex')
BIN_DIR = path.join(__dirname, "..", "bin")

module.exports =
  activate: (@state) ->
    atom.workspaceView.command 'colorpicker:toggle', '.editor:not(.mini)', =>
      activePane = atom.workspaceView.getActivePane()
      @editor = activePane.activeItem
      return unless @editor.getGrammar().scopeName is 'source.css'
      return unless @editor.getSelectedBufferRange().isEmpty()
      cursor = @editor.getCursor()
      line = cursor.getCurrentBufferLine()
      pos = cursor.getBufferPosition()
      colorsData = @detectColors(pos, line)
      return unless colorsData.length > 0
      @toggleColorpicker(colorsData)

  # TODO: support multiple cursors?
  detectColors: (pos, line) ->
    colors = color_regex.scanForColors(line)
    return [] unless colors.length > 0

    start = end = 0
    col = pos.column
    colorsData = []

    for color in colors
      start = line.indexOf(color)
      end = start + color.length + 1
      if (col >= start && col <= end)
        colorsData.push
          color: color
          start: start
          end: end

    return colorsData

  colorPickerPath: ->
    @colorPickerPlatformPath ?= path.join(BIN_DIR, "#{os.platform()}-colorpicker")

  toggleColorpicker: (colorsData) ->
    fs.exists @colorPickerPath(), (exists) =>
      return console.error "No colorpicker available for #{os.platform()}" unless exists
      fs.stat @colorPickerPath(), (err, stats) =>
        throw err if err
        executable = !!(1 & parseInt((stats.mode & parseInt("777", 8)).toString(8)[0]))
        fs.chmodSync(colorpicker, '755') unless executable

        @showColorpickerDialog(colorsData)

  showColorpickerDialog: (colorsData) ->
    oldColor = colorsData[0]["color"]
    args = ["-startColor", oldColor]
    @newColor = null
    @originalColorFormat = tinycolor(oldColor).format

    if @originalColorFormat == "hex"
      switch oldColor.length - 1
        when 3 then @originalColorFormat = "hex3"
        when 6 then @originalColorFormat = "hex6"
        when 8 then @originalColorFormat = "hex8"

    colorpicker = @spawnColorPicker(args)

    colorpicker.stdout.on 'data', (data) =>
      @newColor = tinycolor String(data), { format: @originalColorFormat }

    colorpicker.on 'close', (code) =>
      @replaceSelectedTextWithMatch(@newColor, colorsData) if code == 0 && @newColor?

  spawnColorPicker: (args) ->
    spawn @colorPickerPath(), args

  replaceSelectedTextWithMatch: (newColor, colorsData) ->
    selection = @editor.getSelection()

    bufferRange = selection.getBufferRange()

    newBufferRange =
      start:
        row: bufferRange.start.row
        column: colorsData[0]["start"]
      end:
        row: bufferRange.end.row
        column: colorsData[0]["end"]

    selection.setBufferRange(newBufferRange)

    newColorString = newColor.toString()
    if /^#/.test newColorString
      newColorString = newColorString.substr(1)

    selection.insertText(newColorString)

  getBinDir: -> BIN_DIR
