EventEmitter = require('events').EventEmitter
Consts = require('../consts').default
assign = require('object-assign')
dispatcher = require('../dispatchers/dispatcher')


_files = []
_oldestFile = null
_newestFile = null
ImageStore = assign {}, EventEmitter.prototype,
  getFiles: ->
    return _files
  getOldest: ->
    return _oldestFile
  getNewest: ->
    return _newestFile


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

    when Consts.EVENTS.READ_NEWEST_FILE
      _newestFile = payload.action.file
      ImageStore.emit(Consts.EVENTS.STORE_LOAD)
      return true

    when Consts.EVENTS.READ_OLDEST_FILE
      _oldestFile = payload.action.file
      ImageStore.emit(Consts.EVENTS.STORE_LOAD)
      return true

    when Consts.EVENTS.UPDATE_FILE
      data = payload.action.data
      result = for e in _files.filter((e)-> e.id is data.id)
        e[key] = val for key, val of data
        e
      ImageStore.emit(Consts.EVENTS.STORE_UPDATE, result)
      return true

    when Consts.EVENTS.DELETE_FILE
      data = payload.action.data
      _files = _files.filter((e)-> e.id isnt data.id)
      ImageStore.emit(Consts.EVENTS.STORE_DELETE, data)
      return true

    else
      return true

module.exports = ImageStore

