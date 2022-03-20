{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.19.1";
    sha256 = "sha256-4a4J3YYas5rwRIO7XA+lTd2CtrFVQ76aJ+pnBKi6ndk=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
