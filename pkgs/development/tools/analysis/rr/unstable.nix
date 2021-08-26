# This is a temporary copy of the default.nix in this folder, with the version
# updated to the current tip of rr's master branch. This exists because rr has
# not had a release in a long time. Upstream has stated that it should be fine
# to use master. This file, and its attribute in all-packages, can be removed
# once rr makes a release.

{ callPackage, fetchFromGitHub }:

let
  rr = callPackage ./. {};
in

  rr.overrideAttrs (old: {
    version = "unstable-2021-07-06";

    src = fetchFromGitHub {
      owner = "mozilla";
      repo = "rr";
      rev = "0fc21a8d654dabc7fb1991d76343824cb7951ea0";
      sha256 = "0s851rflxmvxcfw97zmplcwzhv86xmd3my78pi4c7gkj18d621i5";
    };
  })
