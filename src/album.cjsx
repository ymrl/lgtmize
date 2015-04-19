React = require 'react'
AlbumViewer = require('./components/album_viewer')

React.render React.createElement(AlbumViewer, null),
  document.querySelector('.main')

