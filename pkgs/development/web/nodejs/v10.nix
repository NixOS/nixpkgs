{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.0.0";
    sha256 = "1m5xr2ls76q4x05d9mcwcyqq5bhli81w8s6f5wqgxkbnzfab8ni3";
  }
