{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.3";
    sha256 = "0j3zd5vavsapqs9h682mr8r5i7xp47n0w4vjvm8rw3rn3dg4p2sb";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
