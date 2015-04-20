React = require 'react'
Actions = require('../actions/common')

AlbumImage = React.createClass
  handleClick: (e)->
    @props.onClick(@props.file)
    e.preventDefault()

  render: ->
    linkUrl = if @props.file.url
      @props.file.url
    else
      Actions.loadImageSrc(@props.file)
      'javascript:void(0)'

    <a target="_blank" href={linkUrl} className="album-image" onClick={@handleClick}>
      {
        if @props.file.url
          <img src={@props.file.url} alt={@props.file.fileName} className={if @props.file.width > @props.file.height then 'landscape' else 'portlait'} />
        else
          <div className="substitute">{@props.file.fileName}</div>
      }
    </a>

module.exports = AlbumImage
