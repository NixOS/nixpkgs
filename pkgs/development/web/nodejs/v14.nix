{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.2";
    sha256 = "0gjq61l1lm15bv47w0phil44nbh0fsq3mmqf40xxlm92gswb4psg";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
