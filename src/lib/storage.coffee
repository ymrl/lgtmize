DB_VER = 7
IMAGE_OBJECT_STORE = 'images'
FileSystem = require('./file_system')

db = null
init = (callback)->
  req = indexedDB.open('lgtm_db', DB_VER)
  req.onupgradeneeded = (e)->
    conn = e.target.result
    oldVer = e.oldVersion
    if oldVer < DB_VER
      conn.createObjectStore IMAGE_OBJECT_STORE,
        keyPath: 'id'
        autoIncrement: true
  req.onsuccess = (e)->
   db = e.target.result
   callback()

handleDB = (callback)->
  if db
    callback()
  else
    init(-> callback())

exports =
  saveImage: (data, callback)->
    handleDB ->
      FileSystem.saveDataURL data.url, (fileName)->
        tx = db.transaction([IMAGE_OBJECT_STORE], 'readwrite')
        store = tx.objectStore(IMAGE_OBJECT_STORE)
        data =
          fileName: fileName
          width: data.width
          height: data.height
          timestamp: (new Date()).getTime()
        req = store.put data
        tx.oncomplete = (e)->
          callback(data)

  loadFiles: (callback)->
    handleDB ->
      tx = db.transaction([IMAGE_OBJECT_STORE], 'readonly')
      store = tx.objectStore(IMAGE_OBJECT_STORE)
      range = IDBKeyRange.lowerBound(0)
      cursorRequest = store.openCursor(range)
      arr = []
      cursorRequest.onsuccess = (e) ->
        result = e.target.result
        unless result
          callback arr
          return
        arr.push result.value
        result.continue()

module.exports = exports

