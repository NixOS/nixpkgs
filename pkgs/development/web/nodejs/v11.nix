{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.13.0";
    sha256 = "12n3bm21q8nm6wn116c0af8fpmxhaa7xd4srrba36q0zl4nra4bl";
  }
