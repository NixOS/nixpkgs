{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.6";
    sha256 = "0yhgkcp7lx5nglxsrybbjymx1fys3wkbbhkj6h6652gnp0b2y0n2";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
