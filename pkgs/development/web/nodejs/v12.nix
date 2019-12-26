{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.14.0";
    sha256 = "0wdyz6fymkf2pfb5bf5ddcza7f2n55p9zqjvq661nr5gl9xj32h8";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin.patch ];
  }
