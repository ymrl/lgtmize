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
      file: null,
      oldest: null,
      newest: null
    };
  },
  componentDidMount: function componentDidMount() {
    ImageStore.on(Consts.EVENTS.STORE_LOAD, this.onStoreLoad);
    ImageStore.on(Consts.EVENTS.STORE_UPDATE, this.onUpdateFile);
    ImageStore.on(Consts.EVENTS.STORE_DELETE, this.onDeleteFile);
    Actions.loadOlder();
    Actions.loadOldest();
    Actions.loadNewest();
  },
  componentWillUnmount: function componentWillUnmount() {
    ImageStore.removeListener(Consts.EVENTS.STORE_LOAD, this.onStoreLoad);
    ImageStore.removeListener(Consts.EVENTS.STORE_UPDATE, this.onUpdateFile);
    return ImageStore.removeListener(Consts.EVENTS.STORE_DELETE, this.onDeleteFile);
  },
  onStoreLoad: function onStoreLoad() {
     this.setState({
      files: ImageStore.getFiles(),
      oldest: ImageStore.getOldest(),
      newest: ImageStore.getNewest()
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
  loadOlder: function(){
    var len = this.state.files.length;
    if(len > 0){
      Actions.loadOlder(this.state.files[len - 1].timestamp);
    }else {
      Actions.loadOlder();
    }
  },
  loadNewer: function(){
    var len = this.state.files.length;
    if(len > 0){
      Actions.loadNewer(this.state.files[0].timestamp);
    }else {
      Actions.loadOlder();
    }
  },
  render: function render() {
    var imageNodes = this.state.files.map((file) => {
      return <AlbumImage
        key={file.id}
        file={file}
        onClick={this.handleClick}
      />
    });
    var newerExist = this.state.newest && this.state.files[0] && this.state.newest.timestamp > this.state.files[0].timestamp;
    var olderExist = this.state.oldest && this.state.files[this.state.files.length -1] &&
      this.state.oldest.timestamp < this.state.files[this.state.files.length -1].timestamp;
    return <div>
      <button onClick={this.loadNewer} disabled={!newerExist}>Newer</button>
      <button onClick={this.loadOlder} disabled={!olderExist}>Older</button>
      <section className="image-list">
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
      </section>
    </div>;
  }
});
export default AlbumViewer;
