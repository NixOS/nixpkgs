{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  documentationTarball = callPackage ./documentationTarball { };
  setBuildTarget = callPackage ./setBuildTarget { };
}
