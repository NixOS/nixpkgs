{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.14.1";
    sha256 = "1nvsivl496fgaypbk2pqqh7py29g7wsggyjlqydy1c0q4f24nyw7";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin.patch ];
  }
