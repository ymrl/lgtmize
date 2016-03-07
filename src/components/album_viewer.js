import React from 'react';
import Actions from '../actions/common';
import ImageStore from '../stores/image_store';
import Consts from '../consts';
import AlbumImage from './album_image';
import ImageDetail from './image_detail';
import Modal from 'react-modal';

class AlbumViewer extends React.Component {
  constructor() {
    super();
    this.state = {
      modalOpen: false,
      file: null,
    };
  }

  handleCloseDetail() {
    return this.setState({
      modalOpen: false
    });
  }

  handleRemoveImage(e) {
    if (this.state.file) {
      Actions.removeImage(this.state.file);
    }
    return this.setState({
      modalOpen: false
    });
  }

  handleClick(file) {
    return this.setState({
      modalOpen: true,
      file: file
    });
  }

  loadOlder(){
    var len = this.props.files.length;
    if(len > 0){
      Actions.loadOlder(this.props.files[len - 1].timestamp);
    }else {
      Actions.loadOlder();
    }
  }

  loadNewer(){
    var len = this.props.files.length;
    if(len > 0){
      Actions.loadNewer(this.props.files[0].timestamp);
    }else {
      Actions.loadOlder();
    }
  }

  render() {
    const {files, oldest, newest} = this.props;
    const imageNodes = files.map((file) => {
      return <AlbumImage
        key={file.id}
        file={file}
        onClick={this.handleClick.bind(this, file)}
      />
    });
    const newerExist = newest && files[0] && newest.timestamp > files[0].timestamp;
    const olderExist = oldest && files[files.length -1] &&
      oldest.timestamp < files[files.length -1].timestamp;
    return <div>
      <button onClick={this.loadNewer.bind(this)} disabled={!newerExist}>Newer</button>
      <button onClick={this.loadOlder.bind(this)} disabled={!olderExist}>Older</button>
      <section className="image-list">
        {imageNodes}
        <Modal isOpen={this.state.modalOpen} >
          <div className="detail-modal-content">
            <div className="controls">
              <button className="remove-button" onClick={this.handleRemoveImage.bind(this)} tabIndex="-1">Remove</button>
              <button className="close-button" onClick={this.handleCloseDetail.bind(this)}>Close</button>
            </div>
            <ImageDetail file={this.state.file} />
          </div>
        </Modal>
      </section>
    </div>;
  }
}

export default AlbumViewer;
