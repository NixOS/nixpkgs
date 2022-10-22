{ callPackage, python3, lib, stdenv, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.20.1";
    sha256 = "sha256-NlBX6mYZI8v6cb3XqNCs6d3/jSLUMa2SNV+EM87P8U0=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
