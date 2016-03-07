import React from  'react';
import ReactDOM from 'react-dom'
import Modal from 'react-modal';
import Consts from './consts';
import Actions from './actions/common';
import AlbumContainer from './containers/album_container';

var mainElement = document.querySelector('.main')

Modal.setAppElement(mainElement);

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse){
  if(request.type === Consts.MESSAGES.CREATED){
    Actions.loadOlder();
  }
});

ReactDOM.render(React.createElement(AlbumContainer), mainElement);
Actions.loadOlder();
Actions.loadOldest();
Actions.loadNewest();
