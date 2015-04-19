LGTM_IMG = 'img/lgtm.png'

lgtm =
  createLGTM: (url, callback) ->
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
      callback(url: canvas.toDataURL(), width: w, height: h)
    ,(e)-> console.log e

  imageToDataURL: (url, callback)->
    load = new Promise (resolve, reject)->
      sourceImg = document.createElement('img')
      onLoad = ->
        resolve
          source: sourceImg
      onError = (e)->
        reject(e)
      sourceImg.addEventListener 'load', onLoad
      sourceImg.addEventListener 'error', onError
      sourceImg.src = url

    load.then (data)->
      source = data.source
      canvas = document.createElement('canvas')
      sw = source.naturalWidth
      sh = source.naturalHeight
      return if sw is 0 or sh is 0
      canvas.width = sw
      canvas.height = sh
      context = canvas.getContext('2d')
      context.drawImage(source, 0, 0, sw, sh, 0, 0,  sw, sh)
      callback(url: canvas.toDataURL(), width: sw, height: sh)
    ,(e)-> console.log e

module.exports = lgtm
