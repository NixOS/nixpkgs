{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.14.1";
    sha256 = "16vb5baw6nk71n7jfbyd9x8qi0kbkzv2bw1rczy7dyyz7n08gpxi";
  }
