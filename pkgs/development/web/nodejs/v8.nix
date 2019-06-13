{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.16.0";
    sha256 = "0h3k5y51fyysqnqb8n5v5zxga937pipag49xzx6xr9b82phfh59m";
  }
