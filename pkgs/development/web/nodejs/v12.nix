{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.11";
    sha256 = "sha256-XoHaJv1bH4lxRIOrqmjj2jBFI+QzTHjEm/p6A+541vE=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
