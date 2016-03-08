Consts = require('../consts').default
dispatcher = require('../dispatchers/dispatcher')
lgtm = require('../lib/lgtm')
createLGTM = lgtm.createLGTM
imageToDataURL = lgtm.imageToDataURL
storage = require('../lib/storage').default

actions =
  loadOlder: (olderThan=null, limit=15)->
    storage.loadOlderFiles olderThan, limit, 'prev', (files)->
      dispatcher.dispatch
        actionType: Consts.EVENTS.READ_FILES
        files: files

  loadNewer: (newerThan=null, limit=15)->
    storage.loadNewerFiles newerThan, limit, 'next', (files)->
      dispatcher.dispatch
        actionType: Consts.EVENTS.READ_FILES
        files: files.reverse()

  loadOldest: ->
    storage.loadNewerFiles 0, 1, 'next', (files)->
      dispatcher.dispatch
        actionType: Consts.EVENTS.READ_OLDEST_FILE
        file: files[0]

  loadNewest: ->
    storage.loadOlderFiles (100000000 * 24 * 60 * 60 * 1000), 1, 'prev', (files)->
      dispatcher.dispatch
        actionType: Consts.EVENTS.READ_NEWEST_FILE
        file: files[0]

  loadImageSrc: (data)->
    storage.loadImageSrc data, (d,url)->
      dispatcher.dispatch
        actionType: Consts.EVENTS.UPDATE_FILE
        url: url
        data: d

  removeImage: (data)->
    storage.removeFile data, ->
      dispatcher.dispatch
        actionType: Consts.EVENTS.DELETE_FILE
        data: data

  lgtm: (url)->
    createLGTM url, (data)->
      storage.saveImage data,(record)->
        dispatcher.dispatch
          actionType: Consts.EVENTS.CREATED
          data: record
          url: data.url

  capture: (url)->
    imageToDataURL url, (data)->
      storage.saveImage data,(record)->
        dispatcher.dispatch
          actionType: Consts.EVENTS.CREATED
          data: record
          url: data.url

module.exports = actions
