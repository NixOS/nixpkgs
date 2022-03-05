{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.19.0";
    sha256 = "sha256-6S6EYwDmEXVH036o1b0yJEwZsvzvyznhQgpHY39FAww=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
