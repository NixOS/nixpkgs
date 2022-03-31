{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  documentationTarball = callPackage ./documentationTarball { };
  ghcjs-eval = callPackage ./ghcjs-eval { };
  setBuildTarget = callPackage ./setBuildTarget { };
  writers = callPackage ./writers { };
}
