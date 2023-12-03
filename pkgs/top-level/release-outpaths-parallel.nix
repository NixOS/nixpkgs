/*
Invocation:


Invocation; note that the number of processes spawned is four times
the number of cores -- this helps in two ways:

1. Keeping cores busy while I/O operations are in flight

2. Since the amount of time needed for the jobs is *not* balanced
   this minimizes the "tail latency" for the very last job to finish
   (on one core) by making the job size smaller.

*/
# see pkgs/top-level/nohydra
{ lib ? import ../../lib
, checkMeta
, includeBroken ? true
, path ? ./../..
, myChunk
, numChunks
, attrPathFile
}:

let
  attrPaths = builtins.fromJSON (builtins.readFile attrPathFile);
  chunkSize = (lib.length attrPaths) / numChunks;
  myPaths =
    let
      dropped = lib.drop (chunkSize*myChunk) attrPaths;
    in
      if myChunk == numChunks - 1
      then dropped
      else lib.take chunkSize dropped;

  unfiltered = import ./release-outpaths.nix {
    inherit checkMeta path includeBroken;
  };

  filtered = lib.pipe myPaths [
    (map (lib.splitString "."))
    (map (path: lib.setAttrByPath path (lib.attrByPath path null unfiltered)))
    (builtins.foldl' lib.recursiveUpdate {})
  ];

  recurseEverywhere = val:
    if lib.isDerivation val || !(lib.isAttrs val)
    then val
    else (builtins.mapAttrs (_: v: recurseEverywhere v) val)
         // { recurseForDerivations = true; };

in
  recurseEverywhere filtered
