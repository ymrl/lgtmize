LGTM_IMG = 'img/lgtm.png'
ALBUM_HTML = 'html/album.html'
ICON_IMG = 'img/icon-128.png'
Consts = require('./consts').default
Actions = require('./actions/common')
ImageStore = require('./stores/image_store')

ImageStore.on Consts.EVENTS.STORE_ADD, (data)->
  chrome.notifications.create
    title: "Image Saved"
    message: "It can be seen in Album Page"
    imageUrl: data.url
    iconUrl: chrome.extension.getURL(ICON_IMG)
    type: 'image'

  chrome.tabs.query {url: chrome.extension.getURL(ALBUM_HTML)}, (result)->
    if result.length is 0
      chrome.tabs.create(url: chrome.extension.getURL(ALBUM_HTML), active: false)
    else
      for tab in result
        chrome.tabs.sendMessage tab.id,
          type: Consts.MESSAGES.CREATED

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  switch request?.type
    when 'lgtm'
      Actions.lgtm(request.dataURL)
    when 'capture'
      Actions.capture(request.dataURL)

loadVideoFromContextMenu = (info, tab, callback)->
  chrome.tabs.sendMessage tab.id,
    type: 'captureVideo'
    url: info.srcUrl
  , (response)->
    return unless response
    callback(response.dataURL)

findVideoFromContextMenu = (info, tab, callback)->
  chrome.tabs.sendMessage tab.id,
    type: 'findVideo'
  , (response)->
    return unless response
    callback(response.dataURL)

MENU_ITEM_FIND_LGTM = 'findVideoAndLgtmize'
MENU_ITEM_FIND_CAPTURE = 'findVideoAndCaputre'
MENU_ITEM_LGTM = 'lgtmize'
MENU_ITEM_CAPTURE = 'capture'
MENU_ITEM_OPEN_ALBUM = 'openalbum'

chrome.notifications.onClicked.addListener ->
  chrome.tabs.create(url: chrome.extension.getURL(ALBUM_HTML), active: true)

chrome.contextMenus.onClicked.addListener (info, tab)->
  switch info.menuItemId
    when MENU_ITEM_FIND_LGTM
      findVideoFromContextMenu info, tab, (url)->
        Actions.lgtm(url)

    when MENU_ITEM_FIND_CAPTURE
      findVideoFromContextMenu info, tab, (url)->
        Actions.capture(url)

    when MENU_ITEM_LGTM
      if info.mediaType is 'video'
        loadVideoFromContextMenu info, tab, (url)->
          Actions.lgtm(url)
      else
        Actions.lgtm(info.srcUrl)

    when MENU_ITEM_CAPTURE
      if info.mediaType is 'video'
        loadVideoFromContextMenu info, tab, (url)->
          Actions.capture(url)
      else
        Actions.capture(info.srcUrl)

    when MENU_ITEM_OPEN_ALBUM
      chrome.tabs.create(url: chrome.extension.getURL(ALBUM_HTML))

chrome.runtime.onInstalled.addListener ->
  parent = chrome.contextMenus.create
    type: 'normal'
    title: 'LGTMize'
    contexts: ['all']
    id: 'parent'
  chrome.contextMenus.create
    type: 'normal'
    title: 'LGTMize'
    contexts: ['video','image']
    parentId: parent
    id: MENU_ITEM_LGTM
  chrome.contextMenus.create
    type: 'normal'
    title: 'Capture As LGTM'
    contexts: ['video', 'image']
    parentId: parent
    id: MENU_ITEM_CAPTURE
  chrome.contextMenus.create
    type: 'normal'
    title: 'Find Video and LGTMize'
    contexts: ['all']
    parentId: parent
    id: MENU_ITEM_FIND_LGTM
  chrome.contextMenus.create
    type: 'normal'
    title: 'Find Video and Captre'
    contexts: ['all']
    parentId: parent
    id: MENU_ITEM_FIND_CAPTURE
  chrome.contextMenus.create
    type: 'normal'
    title: 'Open Album'
    contexts: ['all']
    parentId: parent
    id: MENU_ITEM_OPEN_ALBUM
