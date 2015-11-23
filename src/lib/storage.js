import FileSystem from './file_system';

var DB_VER = 8,
    DB_INITIALIZED_VER = 7,
    ADD_INDEX_TO_TIMESTAMP_VER = 8,
    IMAGE_OBJECT_STORE = 'images',
    TIMESTAMP_INDEX = 'timestampIndex',
    db = null;

var init = function (callback) {
  var req;
  req = indexedDB.open('lgtm_db', DB_VER);
  req.onupgradeneeded = function (e) {
    var conn, oldVer, store;
    conn = e.target.result;
    oldVer = e.oldVersion;
    if (oldVer < DB_INITIALIZED_VER) {
      store = conn.createObjectStore(IMAGE_OBJECT_STORE, {
        keyPath: 'id',
        autoIncrement: true
      });
    }
    if (oldVer < ADD_INDEX_TO_TIMESTAMP_VER) {
      store = this.transaction.objectStore(IMAGE_OBJECT_STORE);
      return store.createIndex(TIMESTAMP_INDEX, 'timestamp', {
        unique: false,
        multiEntry: false
      });
    }
  };
  return req.onsuccess = function (e) {
    db = e.target.result;
    return callback();
  };
};

var handleDB = function (callback) {
  if (db) {
    return callback();
  } else {
    return init(function () {
      return callback();
    });
  }
};

var exports = {
  saveImage: function saveImage(data, callback) {
    return handleDB(function () {
      return FileSystem.saveDataURL(data.url, function (fileName) {
        var req, store, tx;
        tx = db.transaction([IMAGE_OBJECT_STORE], 'readwrite');
        store = tx.objectStore(IMAGE_OBJECT_STORE);
        data = {
          fileName: fileName,
          width: data.width,
          height: data.height,
          timestamp: new Date().getTime()
        };
        req = store.put(data);
        return tx.oncomplete = function (e) {
          return callback(data);
        };
      });
    });
  },
  loadOlderFiles: function loadOlderFiles(olderThan, limit, direction, callback) {
    olderThan = olderThan || (new Date()).getTime()
    handleDB(function () {
      var tx = db.transaction([IMAGE_OBJECT_STORE], 'readonly');
      var store = tx.objectStore(IMAGE_OBJECT_STORE);
      var index = store.index(TIMESTAMP_INDEX);
      var range = IDBKeyRange.upperBound(olderThan);
      var cursorRequest = index.openCursor(range, direction);
      var arr = [];
      var count = 0;

      cursorRequest.onsuccess = function (e) {
        var result;
        result = e.target.result;

        if(result){
          arr.push(result.value);
          count++;
        }
        if (!result || count >= limit ) {
          callback(arr);
          return;
        }
        result["continue"]();
      };
    });
  },
  loadNewerFiles: function loadNewerFiles(newerThan, limit, direction, callback) {
    if(!newerThan && newerThan !== 0){
      newerThan = (new Date()).getTime();
    }
    handleDB(function () {
      var tx = db.transaction([IMAGE_OBJECT_STORE], 'readonly');
      var store = tx.objectStore(IMAGE_OBJECT_STORE);
      var index = store.index(TIMESTAMP_INDEX);
      var range = IDBKeyRange.lowerBound(newerThan);
      var cursorRequest = index.openCursor(range, direction);
      var arr = [];
      var count = 0;

      cursorRequest.onsuccess = function (e) {
        var result;
        result = e.target.result;

        if(result){
          arr.push(result.value);
          count++;
        }
        if (!result || count >= limit ) {
          callback(arr);
          return;
        }
        result["continue"]();
      };
    });
  },
  removeFile: function removeFile(data, callback) {
    return handleDB(function () {
      var req, store, tx;
      tx = db.transaction([IMAGE_OBJECT_STORE], 'readwrite');
      store = tx.objectStore(IMAGE_OBJECT_STORE);
      req = store["delete"](data.id);
      tx.oncomplete = function (e) {
        FileSystem.removeFile(data.fileName, function () {
          callback();
        });
      };
    });
  },
  loadImageSrc: function loadImageSrc(data, callback) {
    return FileSystem.getFileUrl(data.fileName, function (url) {
      data.url = url;
      return callback(data, url);
    });
  }
};

export default exports;

