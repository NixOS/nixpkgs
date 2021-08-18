{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.5";
    sha256 = "1a0zj505nhpfcj19qvjy2hvc5a7gadykv51y0rc6032qhzzsgca2";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
