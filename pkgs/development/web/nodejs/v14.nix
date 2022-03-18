{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.19.1";
    sha256 = "1ncxpal08rza4ydbwhsmn6v85padll7mrfw38kq9mcqshvfhkbp1";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
