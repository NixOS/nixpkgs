{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  cabalSdist = callPackage ./cabalSdist { };
  documentationTarball = callPackage ./documentationTarball { };
  setBuildTarget = callPackage ./setBuildTarget { };
  incremental = callPackage ./incremental { };
  upstreamStackHpackVersion = callPackage ./upstreamStackHpackVersion { };
}
