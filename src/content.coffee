video2canvas = require('./lib/video2canvas')

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.type is 'captureVideo' && request.url
    videos = document.querySelectorAll("video")
    for video in videos
      if video.currentSrc is request.url
        canvas = video2canvas(video)
        sendResponse(dataURL: canvas.toDataURL())
        break
  else if request.type is 'findVideo'
    videos = document.querySelectorAll("video")
    result = for video in videos
      canvas = video2canvas(video)
      try
        sendResponse(dataURL: canvas.toDataURL())
      catch
        window.alert 'Video found but failed to export'
    unless result?.length > 0
      window.alert 'Video not found'


if /^video\//.test(document?.contentType)
  createImage = ->
    video = document.querySelector('video')
    canvas = video2canvas(video)
    chrome.runtime.sendMessage({type: 'capture', dataURL: canvas.toDataURL()}, ->)

  createLGTM = ->
    video = document.querySelector('video')
    canvas = video2canvas(video)
    chrome.runtime.sendMessage({type: 'lgtm', dataURL: canvas.toDataURL()}, ->)

  document.body.addEventListener 'keydown', (e)->
    switch e.keyCode
      when 87 then createImage()
      when 81 then createLGTM()
