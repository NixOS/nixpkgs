{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.19.2";
    sha256 = "sha256-70N1qRUv9p8oI9eyCjtTdnoEYWS7rHgkQpyyFtFojPA=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
