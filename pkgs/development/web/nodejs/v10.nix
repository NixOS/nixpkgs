{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.23.1";
    sha256 = "1ypddif8jc8qrw9n1f8zbpknjcbnjc9xhpm57hc5nqbrmzsidal8";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
