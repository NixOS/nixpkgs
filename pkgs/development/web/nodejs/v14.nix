{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.1";
    sha256 = "0zr4b9gja8f9611rnmc9yacmh90bd76xv9ayikcyqdfzdpax5wfx";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
