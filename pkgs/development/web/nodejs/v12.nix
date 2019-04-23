{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.0.0";
    sha256 = "0y7wrf7id3zawfgqcscbbxmll4h1ij7mwxms14wcywfswm88bi4k";
  }
