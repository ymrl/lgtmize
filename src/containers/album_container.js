import React from 'react';
import { Container } from 'flux/utils';
import ImageStore from './../stores/image_store.js';
import AlbumViewer from './../components/album_viewer';

class AlbumContainer extends React.Component {
  static getStores() {
    return [ImageStore];
  }

  static calculateState() {
    return {
      files: ImageStore.getFiles(),
      newest: ImageStore.getNewest(),
      oldest: ImageStore.getOldest()
    }
  }

  render () {
    return <AlbumViewer {...this.state} />;
  }
}
export default Container.create(AlbumContainer);
