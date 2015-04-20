React = require 'react'
Actions = require('../actions/common')

ImageDetail = React.createClass
  render: ->
    linkUrl = if @props.file.url
        @props.file.url
      else
        Actions.loadImageSrc(@props.file)
        'javascript:void(0)'

    <div className="image-detail">
      <a target="_blank" href={linkUrl} className="detail-image" onClick={@handleClick}>
        {
          if @props.file.url
            <img
              src={@props.file.url}
              alt={@props.file.fileName}
              className={if @props.file.width > @props.file.height then 'landscape' else 'portlait'}
            />
        }
      </a>
    </div>


module.exports = ImageDetail
