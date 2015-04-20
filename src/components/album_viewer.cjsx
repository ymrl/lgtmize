React = require 'react'
Actions = require('../actions/common')
ImageStore = require('../stores/image_store')
Consts = require('../consts')

AlbumImage = require('./album_image')
ImageDetail = require('./image_detail')

Modal = require('react-modal')

AlbumViewer = React.createClass
  stores: [ImageStore]

  getInitialState: ->
    files: []
    modalOpen: false
    file: null

  componentDidMount: ->
    ImageStore.on Consts.EVENTS.STORE_LOAD, @onStoreLoad
    ImageStore.on Consts.EVENTS.STORE_UPDATE, @onUpdateFile
    ImageStore.on Consts.EVENTS.STORE_DELETE, @onDeleteFile
    Actions.read()

  componentWillUnmount: ->
    ImageStore.removeListener Consts.EVENTS.STORE_LOAD, @onStoreLoad
    ImageStore.removeListener Consts.EVENTS.STORE_UPDATE, @onUpdateFile
    ImageStore.removeListener Consts.EVENTS.STORE_DELETE, @onDeleteFile

  onStoreLoad: ->
    @setState
      files: ImageStore.getFiles()

  onUpdateFile: ->
    @setState
      files: ImageStore.getFiles()

  onDeleteFile: (data)->
    @setState
      files: ImageStore.getFiles()
    if @state.file?.id is data.id
      @setState
        modalOpen: false

  handleCloseDetail: ->
    @setState
      modalOpen: false

  handleRemoveImage: (e)->
    if @state.file
      Actions.removeImage(@state.file)
    @setState
      modalOpen: false


  handleClick: (file)->
    @setState
      modalOpen: true
      file: file

  render: ->
    imageNodes = @state.files.sort((a,b)-> b.timestamp - a.timestamp).map (file)=>
      <AlbumImage
        file={file}
        onClick={@handleClick}
      />
    <section className="image-list">
      {imageNodes}
      <Modal isOpen={@state.modalOpen} >
        <div className="detail-modal-content">
          <div className="controls">
            <button className="remove-button" onClick={@handleRemoveImage} tabIndex="-1">Remove</button>
            <button className="close-button" onClick={@handleCloseDetail}>Close</button>
          </div>
          <ImageDetail file={@state.file} />
        </div>
      </Modal>
    </section>
module.exports = AlbumViewer
