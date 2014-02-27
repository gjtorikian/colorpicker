# a port of my code from http://git.io/Hb1itw

module.exports =
  joinedMatcherRegExp: null

  # constructs a giant regexp of the color matchers
  constructMatcherRegExp: ->
    return @joinedMatcherRegExp if @joinedMatcherRegExp != null

    @joinedMatcherRegExp = []
    name = null
    match = null

    for name, value of @names
      # "\\b" prevents matches on words like imporTANt
      @joinedMatcherRegExp.push("\\b" + name + "\\b")

    for type, match of @matchers()
      @joinedMatcherRegExp.push("(?:\\s*|\\b)" + match + "\\b")

    @joinedMatcherRegExp = new RegExp(@joinedMatcherRegExp.join("|"), "gi");
    return @joinedMatcherRegExp

  # Given a string, determines if it has a valid color.
  # Returns an array of matched objects if it does, or an empty array otherwise.
  scanForColors: (text) ->
    results = []
    match = null
    lines = text.split("\n")

    # for each line, try to find a match. if it's found, turn it into a tinycolor
    # and append it to the results
    for line in lines
      if match = line.match(@constructMatcherRegExp())
        while match.length > 0
          stringMatch = match.shift().trim()
          results.push(stringMatch)

    return results

  # copy-pasta'd the below from tinycolor: https://github.com/bgrins/TinyColor
  names:
    aliceblue: "f0f8ff"
    antiquewhite: "faebd7"
    aqua: "0ff"
    aquamarine: "7fffd4"
    azure: "f0ffff"
    beige: "f5f5dc"
    bisque: "ffe4c4"
    black: "000"
    blanchedalmond: "ffebcd"
    blue: "00f"
    blueviolet: "8a2be2"
    brown: "a52a2a"
    burlywood: "deb887"
    burntsienna: "ea7e5d"
    cadetblue: "5f9ea0"
    chartreuse: "7fff00"
    chocolate: "d2691e"
    coral: "ff7f50"
    cornflowerblue: "6495ed"
    cornsilk: "fff8dc"
    crimson: "dc143c"
    cyan: "0ff"
    darkblue: "00008b"
    darkcyan: "008b8b"
    darkgoldenrod: "b8860b"
    darkgray: "a9a9a9"
    darkgreen: "006400"
    darkgrey: "a9a9a9"
    darkkhaki: "bdb76b"
    darkmagenta: "8b008b"
    darkolivegreen: "556b2f"
    darkorange: "ff8c00"
    darkorchid: "9932cc"
    darkred: "8b0000"
    darksalmon: "e9967a"
    darkseagreen: "8fbc8f"
    darkslateblue: "483d8b"
    darkslategray: "2f4f4f"
    darkslategrey: "2f4f4f"
    darkturquoise: "00ced1"
    darkviolet: "9400d3"
    deeppink: "ff1493"
    deepskyblue: "00bfff"
    dimgray: "696969"
    dimgrey: "696969"
    dodgerblue: "1e90ff"
    firebrick: "b22222"
    floralwhite: "fffaf0"
    forestgreen: "228b22"
    fuchsia: "f0f"
    gainsboro: "dcdcdc"
    ghostwhite: "f8f8ff"
    gold: "ffd700"
    goldenrod: "daa520"
    gray: "808080"
    green: "008000"
    greenyellow: "adff2f"
    grey: "808080"
    honeydew: "f0fff0"
    hotpink: "ff69b4"
    indianred: "cd5c5c"
    indigo: "4b0082"
    ivory: "fffff0"
    khaki: "f0e68c"
    lavender: "e6e6fa"
    lavenderblush: "fff0f5"
    lawngreen: "7cfc00"
    lemonchiffon: "fffacd"
    lightblue: "add8e6"
    lightcoral: "f08080"
    lightcyan: "e0ffff"
    lightgoldenrodyellow: "fafad2"
    lightgray: "d3d3d3"
    lightgreen: "90ee90"
    lightgrey: "d3d3d3"
    lightpink: "ffb6c1"
    lightsalmon: "ffa07a"
    lightseagreen: "20b2aa"
    lightskyblue: "87cefa"
    lightslategray: "789"
    lightslategrey: "789"
    lightsteelblue: "b0c4de"
    lightyellow: "ffffe0"
    lime: "0f0"
    limegreen: "32cd32"
    linen: "faf0e6"
    magenta: "f0f"
    maroon: "800000"
    mediumaquamarine: "66cdaa"
    mediumblue: "0000cd"
    mediumorchid: "ba55d3"
    mediumpurple: "9370db"
    mediumseagreen: "3cb371"
    mediumslateblue: "7b68ee"
    mediumspringgreen: "00fa9a"
    mediumturquoise: "48d1cc"
    mediumvioletred: "c71585"
    midnightblue: "191970"
    mintcream: "f5fffa"
    mistyrose: "ffe4e1"
    moccasin: "ffe4b5"
    navajowhite: "ffdead"
    navy: "000080"
    oldlace: "fdf5e6"
    olive: "808000"
    olivedrab: "6b8e23"
    orange: "ffa500"
    orangered: "ff4500"
    orchid: "da70d6"
    palegoldenrod: "eee8aa"
    palegreen: "98fb98"
    paleturquoise: "afeeee"
    palevioletred: "db7093"
    papayawhip: "ffefd5"
    peachpuff: "ffdab9"
    peru: "cd853f"
    pink: "ffc0cb"
    plum: "dda0dd"
    powderblue: "b0e0e6"
    purple: "800080"
    red: "f00"
    rosybrown: "bc8f8f"
    royalblue: "4169e1"
    saddlebrown: "8b4513"
    salmon: "fa8072"
    sandybrown: "f4a460"
    seagreen: "2e8b57"
    seashell: "fff5ee"
    sienna: "a0522d"
    silver: "c0c0c0"
    skyblue: "87ceeb"
    slateblue: "6a5acd"
    slategray: "708090"
    slategrey: "708090"
    snow: "fffafa"
    springgreen: "00ff7f"
    steelblue: "4682b4"
    tan: "d2b48c"
    teal: "008080"
    thistle: "d8bfd8"
    tomato: "ff6347"
    turquoise: "40e0d0"
    violet: "ee82ee"
    wheat: "f5deb3"
    white: "fff"
    whitesmoke: "f5f5f5"
    yellow: "ff0"
    yellowgreen: "9acd32"

   matchers: ->
    # <http://www.w3.org/TR/css3-values/#integers>
    CSS_INTEGER = "[-\\+]?\\d+%?"

    # <http://www.w3.org/TR/css3-values/#number-value>
    CSS_NUMBER = "[-\\+]?\\d*\\.\\d+%?"

    # Allow positive/negative integer/number.  Don't capture the either/or, just the entire outcome.
    CSS_UNIT = "(?:" + CSS_NUMBER + ")|(?:" + CSS_INTEGER + ")"

    # Actual matching.
    # Parentheses and commas are optional, but not required.
    # Whitespace can take the place of commas or opening paren
    PERMISSIVE_MATCH3 = "[\\s|\\(]+(" + CSS_UNIT + ")[,|\\s]+(" + CSS_UNIT + ")[,|\\s]+(" + CSS_UNIT + ")\\s*\\)?"
    PERMISSIVE_MATCH4 = "[\\s|\\(]+(" + CSS_UNIT + ")[,|\\s]+(" + CSS_UNIT + ")[,|\\s]+(" + CSS_UNIT + ")[,|\\s]+(" + CSS_UNIT + ")\\s*\\)?"

    # N.B. converted these all to strings, added "#" for the hexes
    matchers =
      rgb: "rgb" + PERMISSIVE_MATCH3
      rgba: "rgba" + PERMISSIVE_MATCH4
      hsl: "hsl" + PERMISSIVE_MATCH3
      hsla: "hsla" + PERMISSIVE_MATCH4
      hsv: "hsv" + PERMISSIVE_MATCH3
      hex3: "#([0-9a-fA-F]{1})([0-9a-fA-F]{1})([0-9a-fA-F]{1})"
      hex6: "#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})"
      hex8: "#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})"

    return matchers
