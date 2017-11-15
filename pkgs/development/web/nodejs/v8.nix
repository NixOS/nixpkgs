{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.9.1";
    sha256 = "1q0p9zl260pd8038yvn13lw5whs480dy11ar2ijcm2hgyqhhq5pg";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
