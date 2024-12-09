const _curry2 = require("ramda/src/internal/_curry2");
const _map = require("ramda/src/internal/_map");
const keys = require("ramda/src/keys");

// mapObjIndexed: ((v, k, {k: v}) → v') → {k: v} → {k: v'}
// mapObjIndexedReturnArray: ((v, k, {k: v}) → v') → {k: v} → [v']

/*
 * @example
 *
 *      const xyz = { x: 1, y: 2, z: 3 };
 *      const prependKeyAndDouble = (num, key, obj) => key + (num * 2);
 *
 *      mapObjIndexedReturnArray(prependKeyAndDouble, xyz); //=> ['x2', 'y4', 'z6']
 */

const mapObjIndexedReturnArray = _curry2((fn, obj) =>
  _map(key => fn(obj[key], key, obj), keys(obj))
);

module.exports = mapObjIndexedReturnArray;
