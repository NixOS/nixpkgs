{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.12.0";
    sha256 = "16j1rrxkhmvpcw689ndw1raql1gz4jqn7n82z55zn63c05cgz7as";
  }
