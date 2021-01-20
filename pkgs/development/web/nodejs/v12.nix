{ callPackage, openssl, icu, python2, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.20.1";
    sha256 = "0lqq6a2byw4qmig98j45gqnl0593xdhx1dr9k7x2nnvhblrfw3p0";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
