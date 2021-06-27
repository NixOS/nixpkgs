{ callPackage, icu68, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.14.0";
    sha256 = "0vm6jdazqjd1plqsgngzvjrafv2d3mdahk6il4ray02gx97dq8l1";
  }
