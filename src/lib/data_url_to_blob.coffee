# http://g6g6g6g6g6.tumblr.com/post/62513404380/dataurl-blob
module.exports = (dataurl,type)->
  type or= 'image/png'
  bin = atob(dataurl.split('base64,')[1])
  len = bin.length
  barr = new Uint8Array(len)
  i = 0
  while i < len
    barr[i] = bin.charCodeAt(i)
    i++
  return new Blob([barr], type: type)
