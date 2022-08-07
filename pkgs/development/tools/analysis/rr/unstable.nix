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
    version = "unstable-2022-05-12";

    src = fetchFromGitHub {
      owner = "mozilla";
      repo = "rr";
      rev = "c96cb688106634ad09af6214aa91252c3a4f74b1";
      sha256 = "sha256-K4cEQnvBXr/j9qXCgIHLqMrRzm96ushTO5STivRj+Mk=";
    };
  })
