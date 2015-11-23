Consts = require('../consts').default
dispatcher = require('../dispatchers/dispatcher')
lgtm = require('../lib/lgtm')
createLGTM = lgtm.createLGTM
imageToDataURL = lgtm.imageToDataURL
storage = require('../lib/storage')

actions =
  read: ->
    storage.loadFiles (files)->
      dispatcher.dispatch
        action:
          actionType: Consts.EVENTS.READ_FILES
          files: files

  loadImageSrc: (data)->
    storage.loadImageSrc data, (d,url)->
      dispatcher.dispatch
        action:
          actionType: Consts.EVENTS.UPDATE_FILE
          url: url
          data: d

  removeImage: (data)->
    storage.removeFile data, ->
      dispatcher.dispatch
        action:
          actionType: Consts.EVENTS.DELETE_FILE
          data: data

  lgtm: (url)->
    createLGTM url, (data)->
      storage.saveImage data,(record)->
        dispatcher.dispatch
          action:
            actionType: Consts.EVENTS.CREATED
            data: record
            url: data.url

  capture: (url)->
    imageToDataURL url, (data)->
      storage.saveImage data,(record)->
        dispatcher.dispatch
          action:
            actionType: Consts.EVENTS.CREATED
            data: record
            url: data.url

module.exports = actions
