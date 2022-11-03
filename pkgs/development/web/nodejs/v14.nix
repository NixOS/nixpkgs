{ callPackage, python3, lib, stdenv, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.21.0";
    sha256 = "sha256-O0vawbrMxUuu4uPbyre7Y1Ikxxbudu5Jqk9vVMKPeZE=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
