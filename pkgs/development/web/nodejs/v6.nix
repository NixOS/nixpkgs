{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "6.17.0";
    sha256 = "0j17cpl1mbqvbaa0bk9n3nd34jdyljbvm53gx8n64bhwly7cgnn1";
  }
