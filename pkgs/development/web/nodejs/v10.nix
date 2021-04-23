{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.24.1";
    sha256 = "032801kg24j04xmf09m0vxzlcz86sv21s24lv9l4cfv08k1c4byp";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
