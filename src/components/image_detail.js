import React from 'react';
import Actions from '../actions/common';

var ImageDetail = React.createClass({

  displayName: 'ImageDetail',
  render: function render() {
    var linkUrl;

    var content, linkUrl;
    linkUrl = this.props.file.url;
    if(!linkUrl){
      Actions.loadImageSrc(this.props.file);
      linkUrl = 'javascript:void(0)';
    }

    return <div className="image-detail">
      <a target="_blank"
          href={linkUrl}
          className="detail-image"
          onClick={this.handleClick}>
          {
            this.props.file.url ?
              <img
                src={this.props.file.url}
                alt={this.props.file.fileName}
                className={this.props.file.width > this.props.file.height ?
                  'landscape' : 'portlait'}
              /> : ''
          }
      </a>
    </div>
  }
});

module.exports = ImageDetail;
