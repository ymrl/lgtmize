React = require 'react'
AlbumViewer = require('./components/album_viewer')
Modal = require('react-modal')

mainElement = document.querySelector('.main')

Modal.setAppElement(mainElement)
Modal.injectCSS()

React.render React.createElement(AlbumViewer, null),
  mainElement

