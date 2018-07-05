{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.6.0";
    sha256 = "13vyzh53j2c4mv3q3yb0hkdpl1mag5705k7kmb8nmcvdhcm78q0r";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ./no-xcodebuild.patch ];
  }
