{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.16.0";
    sha256 = "0236jlb1hxhzqjlmmlxipcycrndiq92c8434iyy7zshh3n4pzqqq";
  }
