###*
  @fileoverview Our application main entry point.

  This example demonstrates a simple TodoMVC component. For full TodoMVC app:
  @see este/bower_components/este-library/este/demos/app/todomvc/index.html.
###

# Let's require what our app needs.
goog.require 'goog.dom.query'
goog.require 'goog.style'
goog.require 'goog.events'

###*
 * Utils
###
goog.provide 'ivolution.app.util.verticalAlign'
###*
 * Vertical aligning of dynamic height divs
###
ivolution.app.util.verticalAlign = ->
  verticalAligns = goog.dom.query ".vertical-align-wrap > div"
  goog.array.forEach verticalAligns, (e) ->
    divSize    = goog.style.getSize e
    windowSize = goog.dom.getViewportSize()
    if divSize.height < windowSize.height
      offset = Math.ceil divSize.height / 2 * -1
      goog.style.setStyle e,
        'margin-top': offset + "px"
        'top': '50%'
    else
      goog.style.setStyle e,
        'margin-top': 0
        'top': 0

###*
 * Application
###
goog.provide 'ivolution.app.backend.start'
###*
  App main entry point. This function should be called before body closing tag.
  @param {Object} data Server side JSON data.
###
ivolution.app.backend.start = (data) ->

  ivolution.app.util.verticalAlign()
  goog.events.listen window, goog.events.EventType.RESIZE, ivolution.app.util.verticalAlign

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'ivolution.app.backend.start', ivolution.app.backend.start