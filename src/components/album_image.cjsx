React = require 'react'
actions = require('../actions/album_actions')

AlbumImage = React.createClass
  render: ->
    linkUrl = if @props.file.url
      @props.file.url
    else
      actions.loadImageSrc(@props.file)
      'javascript:void(0)'

    <a target="_blank" href={linkUrl} className="album-image">
      {
        if @props.file.url
          <img src={@props.file.url} alt={@props.file.fileName} className={if @props.file.width > @props.file.height then 'landscape' else 'portlait'} />
        else
          <div>{@props.file.fileName}</div>
      }
    </a>

module.exports = AlbumImage
