{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "4.8.7";
    sha256 = "1y21wq092d3gmccm2zldbflbbbx7a71wi9l0bpkxvzmgws69liq3";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];
  }
