{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.2";
    sha256 = "1p281hdw3y32pnbfr7cdc9igv2yrzqg16pn4yj3g01pi3mbhbn3z";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
