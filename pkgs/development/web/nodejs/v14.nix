{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.18.0";
    sha256 = "0naqv0aglsqy51pyiz42xz7wx5pfsbyscpdl8rir6kmfl1c52j3b";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
