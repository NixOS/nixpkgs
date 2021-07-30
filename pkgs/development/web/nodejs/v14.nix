{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.4";
    sha256 = "0b6gadc53r07gx6qr6281ifr5m9bgprmfdqyz9zh5j7qhkkz8yxf";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
