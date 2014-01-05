Colorpicker = require '../lib/colorpicker'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Colorpicker", ->
  beforeEach ->
    atom.packages.activatePackage('colorpicker', immediate: true)

  it "has one valid test", ->
    expect("life").toBe "easy"
