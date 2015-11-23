import React from 'react';
import Actions from '../actions/common';
import ImageStore from '../stores/image_store';
import Consts from '../consts';
import AlbumImage from './album_image';
import ImageDetail from './image_detail';
import Modal from 'react-modal';

var AlbumViewer = React.createClass({
  stores: [ImageStore],
  getInitialState: function getInitialState() {
    return {
      files: [],
      modalOpen: false,
      file: null
    };
  },
  componentDidMount: function componentDidMount() {
    ImageStore.on(Consts.EVENTS.STORE_LOAD, this.onStoreLoad);
    ImageStore.on(Consts.EVENTS.STORE_UPDATE, this.onUpdateFile);
    ImageStore.on(Consts.EVENTS.STORE_DELETE, this.onDeleteFile);
    return Actions.read();
  },
  componentWillUnmount: function componentWillUnmount() {
    ImageStore.removeListener(Consts.EVENTS.STORE_LOAD, this.onStoreLoad);
    ImageStore.removeListener(Consts.EVENTS.STORE_UPDATE, this.onUpdateFile);
    return ImageStore.removeListener(Consts.EVENTS.STORE_DELETE, this.onDeleteFile);
  },
  onStoreLoad: function onStoreLoad() {
    return this.setState({
      files: ImageStore.getFiles()
    });
  },
  onUpdateFile: function onUpdateFile() {
    return this.setState({
      files: ImageStore.getFiles()
    });
  },
  onDeleteFile: function onDeleteFile(data) {
    var ref;
    this.setState({
      files: ImageStore.getFiles()
    });
    if (((ref = this.state.file) != null ? ref.id : void 0) === data.id) {
      return this.setState({
        modalOpen: false
      });
    }
  },
  handleCloseDetail: function handleCloseDetail() {
    return this.setState({
      modalOpen: false
    });
  },
  handleRemoveImage: function handleRemoveImage(e) {
    if (this.state.file) {
      Actions.removeImage(this.state.file);
    }
    return this.setState({
      modalOpen: false
    });
  },
  handleClick: function handleClick(file) {
    return this.setState({
      modalOpen: true,
      file: file
    });
  },
  render: function render() {
    var imageNodes;
    imageNodes = this.state.files.sort( (a, b) => {
      return b.timestamp - a.timestamp;
    }).map( (file) => {
      return <AlbumImage
        file={file}
        onClick={this.handleClick}
      />
    });

    return <section className="image-list">
      {imageNodes}
      <Modal isOpen={this.state.modalOpen} >
        <div className="detail-modal-content">
          <div className="controls">
            <button className="remove-button" onClick={this.handleRemoveImage} tabIndex="-1">Remove</button>
            <button className="close-button" onClick={this.handleCloseDetail}>Close</button>
          </div>
          <ImageDetail file={this.state.file} />
        </div>
      </Modal>
    </section>;
  }
});
export default AlbumViewer;
