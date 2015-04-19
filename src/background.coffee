LGTM_IMG = 'img/lgtm.png'

createLGTM = (url) ->
  load = new Promise (resolve, reject)->
    sourceImg = document.createElement('img')
    lgtmImg = document.createElement('img')
    onLoad = ->
      if sourceImg.complete && lgtmImg.complete
        resolve
          source: sourceImg
          lgtm: lgtmImg
    onError = (e)->
      reject(e)
    lgtmImg.addEventListener 'load', onLoad
    sourceImg.addEventListener 'load', onLoad
    lgtmImg.addEventListener 'error', onError
    sourceImg.addEventListener 'error', onError
    lgtmImg.src = chrome.extension.getURL(LGTM_IMG)
    sourceImg.src = url

  load.then (data)->
    source = data.source
    lgtm = data.lgtm
    canvas = document.createElement('canvas')
    sw = source.naturalWidth
    sh = source.naturalHeight
    lw = lgtm.naturalWidth
    lh = lgtm.naturalHeight
    return if sw is 0 or sh is 0
    if sw > sh
      w = Math.min(sw, lw)
      h = sh * (w / sw)
      oh = h
      ow = lw * (h / lh)
    else
      h = Math.min(sh, lh)
      w = sw * (h / sh)
      ow = w
      oh = lh * (w / lw)
    canvas.width = w
    canvas.height = h
    context = canvas.getContext('2d')
    context.drawImage(source, 0, 0, sw, sh, 0, 0,  w,h)
    context.drawImage(lgtm, 0, 0, lw, lh,  (w / 2 - ow / 2), (h / 2 - oh / 2), ow ,oh)
    chrome.tabs.create(url: canvas.toDataURL(), active: false)
  ,(e)-> console.log e

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  switch request?.type
    when 'lgtm'
      createLGTM(request.dataURL)
    when 'capture'
      chrome.tabs.create(url: request.dataURL, active: false)

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

chrome.contextMenus.onClicked.addListener (info, tab)->
  switch info.menuItemId
    when MENU_ITEM_FIND_LGTM
      findVideoFromContextMenu info, tab, (url)->
        createLGTM(url)
    when MENU_ITEM_FIND_CAPTURE
      findVideoFromContextMenu info, tab, (url)->
        chrome.tabs.create(url: url, active: false)
    when MENU_ITEM_LGTM
      if info.mediaType is 'video'
        loadVideoFromContextMenu info, tab, (url)->
          createLGTM(url)
      else
        createLGTM(info.srcUrl)
    when MENU_ITEM_CAPTURE
      loadVideoFromContextMenu info, tab, (url)->
        chrome.tabs.create(url: url, active: false)

chrome.runtime.onInstalled.addListener ->
  parent = chrome.contextMenus.create
    type: 'normal'
    title: 'LGTMize'
    contexts: ['all']
    id: 'parent'
  chrome.contextMenus.create
    type: 'normal'
    title: 'Capture Image'
    contexts: ['video']
    parentId: parent
    id: MENU_ITEM_CAPTURE
  chrome.contextMenus.create
    type: 'normal'
    title: 'LGTMize'
    contexts: ['video','image']
    parentId: parent
    id: MENU_ITEM_LGTM
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
