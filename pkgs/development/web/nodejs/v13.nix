{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.5.0";
    sha256 = "1ng959fm8ls222mmn2vpkw4n4jba02qigpxc8p85jxfj36dsq4ak";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin.patch ];
  }
