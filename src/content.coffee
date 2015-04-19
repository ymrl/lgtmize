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
