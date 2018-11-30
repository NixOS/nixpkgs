{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.12.0";
    sha256 = "1r0aqcxafha13ks8586x77n77zi88db259cpaix0y1ivdh6qkkfr";
  }
