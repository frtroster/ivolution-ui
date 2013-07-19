###*
  @fileoverview Our application main entry point.

  This example demonstrates a simple TodoMVC component. For full TodoMVC app:
  @see este/bower_components/este-library/este/demos/app/todomvc/index.html.
###

# Let's require what our app needs.
goog.require 'goog.dom.query'
goog.require 'goog.style'

goog.provide 'ivolution.app.ui.util.verticalAlign'
###*
 * Vertical aligning of dynamic height divs
###
ivolution.app.ui.util.verticalAlign = ->
  verticalAligns = goog.dom.query ".vertical-align-wrap > div"
  goog.array.forEach verticalAligns, (e) ->
      size   = goog.style.getSize e
      offset = Math.ceil size.height / 2 * -1
      goog.style.setStyle e,
        'margin-top': offset + "px"

goog.provide 'ivolution.app.backend.start'

###*
  App main entry point. This function should be called before body closing tag.
  @param {Object} data Server side JSON data.
###
ivolution.app.backend.start = (data) ->

  ivolution.app.ui.util.verticalAlign()

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'ivolution.app.backend.start', ivolution.app.backend.start