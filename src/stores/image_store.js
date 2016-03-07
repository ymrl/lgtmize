import { ReduceStore } from 'flux/utils';
import assign from 'object-assign';
import dispatcher from '../dispatchers/dispatcher';
import Consts from '../consts';

class ImageStore extends ReduceStore {
  getInitialState () {
    return {
      files: [],
      oldest: null,
      newest: null
    }
  }

  reduce (state, action) {
    switch(action.actionType) {
      case Consts.EVENTS.CREATED:
        const data = assign({}, action.data, { url: action.url });
        return assign({}, state, { files: state.files.concat([data])});
      case Consts.EVENTS.READ_FILES:
        return assign({}, state, { files: action.files });
      case Consts.EVENTS.READ_NEWEST_FILE:
        return assign({}, state, { newest: action.file });
      case Consts.EVENTS.READ_OLDEST_FILE:
        return assign({}, state, { oldest: action.file });
      case Consts.EVENTS.UPDATE_FILE:
        return assign({}, state, {
          files: state.files.map((e) =>
            assign({}, e, e.id === action.data.id ? action.data : {}))
          });
      case Consts.EVENTS.DELETE_FILE:
        return assign({}, state, { files: state.files.filter((e) => e.id !== action.data.id) });
      default:
        return state;
    }
    return state
  }
  getFiles() {
    return this.getState().files;
  }
  getOldest() {
    return this.getState().oldest;
  }
  getNewest() {
    return this.getState().newest;
  }
}

export default (new ImageStore(dispatcher));
