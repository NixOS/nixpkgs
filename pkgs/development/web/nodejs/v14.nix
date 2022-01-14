{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.18.3";
    sha256 = "026nd6vihjdqz4jn0slg89m8m5vvkvjzgg1aip3dcg9lrm1w8fkq";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
