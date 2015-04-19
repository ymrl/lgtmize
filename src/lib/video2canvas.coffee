video2canvas = (video)->
  height = video.videoHeight
  width = video.videoWidth
  canvas = document.createElement('canvas')
  canvas.width = width
  canvas.height = height
  context = canvas.getContext('2d')
  context.drawImage(video, 0 ,0)
  canvas

module.exports = video2canvas
