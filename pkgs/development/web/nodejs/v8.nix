{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.9.0";
    sha256 = "128ir6rkdz1xj55hbflw0sh7snrrvjwgvxmgnka7cyhjkvw5i0mf";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
