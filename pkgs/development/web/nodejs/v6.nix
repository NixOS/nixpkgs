{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "6.12.2";
    sha256 = "1z6sn4b973sxw0h9hd38rjq6cqdkzl5gsd48f793abvarwgpqrrk";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];
  }
