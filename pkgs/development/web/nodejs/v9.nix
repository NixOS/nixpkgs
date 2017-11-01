{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.0.0";
    sha256 = "19az7mxcb3d1aj0f7gvhriyyghn1rwn0425924pa84d6j1mbsljv";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
