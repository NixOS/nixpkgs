{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.11";
    sha256 = "1wfng3p06ypskg27hk1kwhilac6swdlamaw38iqqj7svzlkdm0ay";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
