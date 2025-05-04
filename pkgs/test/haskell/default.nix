{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  cabalSdist = callPackage ./cabalSdist { };
  documentationTarball = callPackage ./documentationTarball { };
  setBuildTarget = lib.recurseIntoAttrs (callPackage ./setBuildTarget { });
  incremental = callPackage ./incremental { };
  upstreamStackHpackVersion = callPackage ./upstreamStackHpackVersion { };
}
