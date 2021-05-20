{ callPackage, icu68, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.0";
    sha256 = "1vf989canwcx0wdpngvkbz2x232yccp7fzs1vcbr60rijgzmpq2n";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
