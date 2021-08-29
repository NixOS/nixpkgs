# This is a temporary copy of the default.nix in this folder, with the version updated to the current tip of rr's master branch.
# This exists because rr has not had a release in a long time, but there have been a lot of improvements including UX.
# Some of the UX improvements help prevent foot shooting.
# Upstream has stated that it should be fine to use master.
# This file, and its attribute in all-packages, can be removed once rr makes a release.
# For further information, please see https://github.com/NixOS/nixpkgs/issues/99535 "Improve support for the rr debugger in nixos containers"

{ callPackage, fetchFromGitHub }:

let
  rr = callPackage ./. {};
in

  rr.overrideAttrs (old: {
    version = "unstable-2020-10-04";

    src = fetchFromGitHub {
      owner = "mozilla";
      repo = "rr";
      rev = "9ff375813a740a0a6ebcdfcebc58bd61ab68c667";
      sha256 = "0raifs6cg5ckpi2445inhy3hfhp4p89s1lkx9z17mcc2g1c1phf5";
    };
  })
