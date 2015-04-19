Consts = require '../consts'
dispatcher = require('../dispatchers/dispatcher')
lgtm = require('../lib/lgtm')
createLGTM = lgtm.createLGTM
imageToDataURL = lgtm.imageToDataURL
lgtm = require('../lib/lgtm')
storage = require('../lib/storage')

actions =
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
