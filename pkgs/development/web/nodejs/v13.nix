{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.0.1";
    sha256 = "1n9w1kvdzdg2j0a41wdkqcl893209lc018sd49xpy1cnr169h6vr";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin-13_x.patch ];
  }
