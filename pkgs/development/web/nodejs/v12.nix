{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.4";
    sha256 = "0k6dwkhpmjcdb71zd92a5v0l82rsk06p57iyjby84lhy2fmlxka4";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
