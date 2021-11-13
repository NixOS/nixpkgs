{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.18.1";
    sha256 = "1vc9rypkgr5i5y946jnyr9jjpydxvm74p1s17rg2zayzvlddg89z";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
