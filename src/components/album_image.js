import React from 'react';
import Actions from '../actions/common';

var AlbumImage = React.createClass({
  handleClick: function(e) {
    this.props.onClick(this.props.file);
    return e.preventDefault();
  },

  render: function() {
    var content, linkUrl;
    linkUrl = this.props.file.url;
    if(!linkUrl){
      Actions.loadImageSrc(this.props.file);
      linkUrl = 'javascript:void(0)';
    }
    if(this.props.file.url){
      content = <img
        src={this.props.file.url}
        alt={this.props.file.fileName}
        className={this.props.file.width > this.props.file.height ? 'landscape': 'portlait'}
       />;
    }else{
      content = <div className="substitute">{this.props.file.fileName}</div>;
    }
    return <a target="_blank"
        href={linkUrl}
        className="album-image" onClick={this.handleClick}
      >{content}</a>;
  }
});
export default AlbumImage;
