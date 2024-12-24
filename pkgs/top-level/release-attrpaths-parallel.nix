# This file works in tandem with ../../ci/eval/default.nix
# It turns ./release-outpaths.nix into chunks of a fixed size
{
  lib ? import ../../lib,
  path ? ../..,
  # The file containing all available attribute paths, which are split into chunks here
  attrpathFile,
  chunkSize,
  myChunk,
  checkMeta,
  includeBroken,
  systems,
}:

let
  attrpaths = lib.importJSON attrpathFile;
  myAttrpaths = lib.sublist (chunkSize * myChunk) chunkSize attrpaths;

  unfiltered = import ./release-outpaths.nix {
    inherit path;
    inherit checkMeta includeBroken systems;
  };

  # Turns the unfiltered recursive attribute set into one that is limited to myAttrpaths
  filtered =
    let
      recurse =
        index: paths: attrs:
        lib.mapAttrs (
          name: values:
          if attrs ? ${name} then
            if lib.any (value: lib.length value <= index + 1) values then
              attrs.${name}
            else
              recurse (index + 1) values attrs.${name}
              # Make sure nix-env recurses as well
              // {
                recurseForDerivations = true;
              }
          else
            null
        ) (lib.groupBy (a: lib.elemAt a index) paths);
    in
    recurse 0 myAttrpaths unfiltered;

in
filtered
