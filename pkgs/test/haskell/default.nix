{ lib, callPackage }:

lib.recurseIntoAttrs {
  cabalSdist = callPackage ./cabalSdist { };
  documentationTarball = callPackage ./documentationTarball { };
  ghcWithPackages = callPackage ./ghcWithPackages { };
  incremental = callPackage ./incremental { };
  setBuildTarget = callPackage ./setBuildTarget { };
  shellFor = callPackage ./shellFor { };
  upstreamStackHpackVersion = callPackage ./upstreamStackHpackVersion { };
}
