{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  cabalSdist = callPackage ./cabalSdist { };
  documentationTarball = callPackage ./documentationTarball { };
  pathsModule = lib.recurseIntoAttrs (callPackage ./pathsModule { });
  setBuildTarget = callPackage ./setBuildTarget { };
  writers = callPackage ./writers { };
}
