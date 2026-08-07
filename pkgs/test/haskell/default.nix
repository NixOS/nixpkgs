{ lib, callPackage }:

lib.recurseIntoAttrs {
  cabalSdist = callPackage ./cabalSdist { };
  stack = callPackage ./stack { };
  documentationTarball = callPackage ./documentationTarball { };
  env = callPackage ./env { };
  ghcWithPackages = callPackage ./ghcWithPackages { };
  incremental = callPackage ./incremental { };
  setBuildTarget = callPackage ./setBuildTarget { };
  shellFor = callPackage ./shellFor { };
  upstreamStackHpackVersion = callPackage ./upstreamStackHpackVersion { };
}
