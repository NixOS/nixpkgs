{ callPackage, python3, lib, stdenv, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.20.0";
    sha256 = "0slrcgiwwn8isp2ih5i2v1d6lsafz7bg6qwxf2lydlc9i14rhl1b";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
