{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.19.2";
    sha256 = "1w4cd38idclw88j7ib5vcihh8yknacxhmcnp4cl9zxig2nlpahzg";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
