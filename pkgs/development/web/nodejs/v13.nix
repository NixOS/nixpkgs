{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.2.0";
    sha256 = "0r0bbwnp77njhdmby7cs2g6yxfprri684s8h3gqq95ks7vgwgvhx";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin.patch ];
  }
