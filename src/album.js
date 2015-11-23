import React from  'react';
import AlbumViewer from './components/album_viewer';
import Modal from 'react-modal';
import Consts from './consts';
import Actions from './actions/common';

var mainElement = document.querySelector('.main')

Modal.setAppElement(mainElement);
Modal.injectCSS();

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse){
  if(request.type === Consts.MESSAGES.CREATED){
    Actions.read();
  }
});
React.render(React.createElement(AlbumViewer, null), mainElement);
