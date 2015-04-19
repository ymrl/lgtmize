LGTM_IMG = 'img/lgtm.png'
ALBUM_HTML = 'html/album.html'
Consts = require './consts'
fileSystem = require('./lib/file_system')
dispatcher = require('./dispatchers/dispatcher')
actions = require('./actions/background_actions')

# imageStore = require('./stores/image_store')
# imageStore.on Consts.EVENTS.STORE_ADD, (data)->
#   chrome.tabs.create(url: data.url, active: false)

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  switch request?.type
    when 'lgtm'
      actions.lgtm(request.dataURL)
    when 'capture'
      actions.capture(request.dataURL)

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

chrome.contextMenus.onClicked.addListener (info, tab)->
  switch info.menuItemId
    when MENU_ITEM_FIND_LGTM
      findVideoFromContextMenu info, tab, (url)->
        actions.lgtm(url)

    when MENU_ITEM_FIND_CAPTURE
      findVideoFromContextMenu info, tab, (url)->
        actions.capture(url)

    when MENU_ITEM_LGTM
      if info.mediaType is 'video'
        loadVideoFromContextMenu info, tab, (url)->
          actions.lgtm(url)
      else
        actions.lgtm(info.srcUrl)

    when MENU_ITEM_CAPTURE
      if info.mediaType is 'video'
        loadVideoFromContextMenu info, tab, (url)->
          actions.capture(url)
      else
        actions.capture(info.srcUrl)

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
