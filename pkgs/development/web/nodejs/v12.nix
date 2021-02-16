{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.20.2";
    sha256 = "0g3dxip7b5j7fzkw4b82ln93fphxn1zpdizbj1ikjv3hy00dc6ln";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
