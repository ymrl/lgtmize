React = require 'react'
AlbumActions = require('../actions/album_actions')
ImageStore = require('../stores/image_store')
Consts = require('../consts')
AlbumImage = require('./album_image')

AlbumViewer = React.createClass
  stores: [ImageStore]

  getInitialState: ->
    files: []

  componentDidMount: ->
    ImageStore.on Consts.EVENTS.STORE_LOAD, @onStoreLoad
    ImageStore.on Consts.EVENTS.STORE_UPDATE, @onUpdateFile
    AlbumActions.read()

  componentWillUnmount: ->
    ImageStore.removeListener Consts.EVENTS.STORE_LOAD, @onStoreLoad
    ImageStore.removeListener Consts.EVENTS.STORE_UPDATE, @onUpdateFile

  onStoreLoad: ->
    @setState
      files: ImageStore.getFiles()

  onUpdateFile: (arr)->
    @setState
      files: ImageStore.getFiles()

  render: ->
    imageNodes = this.state.files.sort((a,b)-> b.timestamp - a.timestamp).map (file)->
      <AlbumImage file={file} />
    <section className="image-list">
      {imageNodes}
    </section>
module.exports = AlbumViewer
