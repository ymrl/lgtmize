React = require 'react'
AlbumViewer = require('./components/album_viewer')
Modal = require('react-modal')
Consts = require './consts'
Actions = require('./actions/common')

mainElement = document.querySelector('.main')

Modal.setAppElement(mainElement)
Modal.injectCSS()

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.type is Consts.MESSAGES.CREATED
    Actions.read()

React.render React.createElement(AlbumViewer, null),
  mainElement

