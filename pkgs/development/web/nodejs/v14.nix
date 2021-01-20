{ callPackage, openssl, python3, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.15.4";
    sha256 = "177cxp4fhmglyx035j8smiy1bp5fz6q2phlcl0a2mdbldkvfrdxd";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
