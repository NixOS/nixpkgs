{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  cabalSdist = callPackage ./cabalSdist { };
  documentationTarball = callPackage ./documentationTarball { };
  setBuildTarget = callPackage ./setBuildTarget { };
<<<<<<< HEAD
  incremental = callPackage ./incremental { };
  upstreamStackHpackVersion = callPackage ./upstreamStackHpackVersion { };
=======
  writers = callPackage ./writers { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
