fileSystem = require('../lib/file_system')
dispatcher = require('../dispatchers/dispatcher')
storage = require('../lib/storage')
Consts = require('../consts')

actions =
  read: ->
    storage.loadFiles (files)->
      dispatcher.dispatch
        action:
          actionType: Consts.EVENTS.READ_FILES
          files: files

  loadImageSrc: (data)->
    fileSystem.getFileUrl data.fileName, (url)->
      data.url = url
      dispatcher.dispatch
        action:
          actionType: Consts.EVENTS.UPDATE_FILE
          url: url
          data: data

module.exports = actions
