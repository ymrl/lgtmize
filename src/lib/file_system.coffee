dataURL2Blob = require('./data_url_to_blob')
md5 = require('blueimp-md5').md5
fileSystem = null
SIZE = 10 * 1024 * 1024

createFileName = (data)->
  return md5(data)

exports =
  getFileSystem: (callback)->
    if fileSystem
      callback(fileSystem)
    else
      window.webkitRequestFileSystem window.PERSISTENT, SIZE, (fs)->
        fileSystem = fs
        callback(fs)

  saveDataURL: (url, callback)->
    blob = dataURL2Blob(url)
    name = createFileName(url)
    suff = blob.type.split('/')[1]
    fileName = "#{name}.#{suff}"
    exports.getFileSystem (fs)->
      fs.root.getFile fileName, {create: true}, (fileEntry)->
        fileEntry.createWriter (writer)->
          writer.write(blob)
          callback(fileName)

  getFileEntries: (callback)->
    exports.getFileSystem (fs)->
      reader = fs.root.createReader()
      reader.readEntries((entries)->callback(entries))

  getFileUrl: (fileName, callback)->
    exports.getFileSystem (fs)->
      fs.root.getFile fileName, {create: false}, (fileEntry)->
        callback(fileEntry.toURL())

  getFileList: (callback)->
    exports.getFileEntries (entries)->
      callback(entries.map((e)->e.toURL()))

  removeFile: (path, callback)->
    exports.getFileSystem (fs)->
      fs.root.getFile path, {create: false}, (fileEntry)->
        fileEntry.remove ->
          callback()

module.exports = exports
