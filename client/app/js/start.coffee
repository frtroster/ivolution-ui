###*
  @fileoverview Our application main entry point.

  This example demonstrates a simple TodoMVC component. For full TodoMVC app:
  @see este/bower_components/este-library/este/demos/app/todomvc/index.html.
###

# This is how we provide namespaces.
goog.provide 'ivolution.app.backend.start'

# Let's require what our app needs.
goog.require 'este.demos.react.start'

###*
  App main entry point. This function should be called before body closing tag.
  @param {Object} data Server side JSON data.
###
ivolution.app.backend.start = (data) ->

  alert "Hello CoffeeScript!"

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'ivolution.app.backend.start', ivolution.app.backend.start