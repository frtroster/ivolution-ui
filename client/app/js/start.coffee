###*
  @fileoverview Our application main entry point.

  This example demonstrates a simple TodoMVC component. For full TodoMVC app:
  @see este/bower_components/este-library/este/demos/app/todomvc/index.html.
###

# Let's require what our app needs.
goog.require 'goog.style'
goog.require 'goog.events'

###*
 * Utils
###
goog.provide 'ivolution.app.util'
###*
 * Vertical aligning of dynamic height divs
###
ivolution.app.util.verticalAlign = ->
  doVerticalAlign = (element)->
    divSize  = goog.style.getSize element
    if divSize.height < document.documentElement.clientHeight
      offset = Math.ceil divSize.height / 2 * -1
      element.style.marginTop = offset + "px"
      element.style.top = '50%'
    else
      element.style.marginTop = 0
      element.style.top = 0

  doVerticalAlign verticalAlign for verticalAlign in document.querySelectorAll ".vertical-align-wrap > div"

ivolution.app.util.modal = ->
  closeModal = (element)->
    element.onclick = ->
      node = this
      node = node.parentNode while !node.hasAttribute "data-coral"
      node.className = node.className.replace " active", ""
      false

  openModal = (element)->
    modalWindow = document.getElementById element.getAttribute "data-coral-id"
    closeModal closeLink for closeLink in modalWindow.querySelectorAll "a.close-coral-modal, a.cancel.button"

    element.onclick = ->
      modalWindow.className += " active"
      false

  openModal modalLink for modalLink in document.querySelectorAll "a[data-coral-id]"

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
  ivolution.app.util.modal()
  goog.events.listen window, goog.events.EventType.RESIZE, ivolution.app.util.verticalAlign

goog.provide 'app.start'

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', ivolution.app.backend.start