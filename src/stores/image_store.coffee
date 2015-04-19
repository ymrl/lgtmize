EventEmitter = require('events').EventEmitter
Consts = require('../consts')
assign = require('object-assign')
dispatcher = require('../dispatchers/dispatcher')


_files = []
ImageStore = assign {}, EventEmitter.prototype,
  getFiles: ->
    return _files

dispatcher.register (payload)->
  actionType = payload.action.actionType
  switch actionType
    when Consts.EVENTS.CREATED
      data = payload.action.data
      data.url = payload.action.url
      _files.push data
      ImageStore.emit(Consts.EVENTS.STORE_ADD, data)
      return true

    when Consts.EVENTS.READ_FILES
      _files = payload.action.files
      ImageStore.emit(Consts.EVENTS.STORE_LOAD)
      return true

    when Consts.EVENTS.UPDATE_FILE
      data = payload.action.data
      result = for e in _files.filter((e)-> e.id is data.id)
        e[key] = val for key, val of data
        e
      ImageStore.emit(Consts.EVENTS.STORE_UPDATE, result)

    else
      return true

module.exports = ImageStore

