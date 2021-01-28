{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.23.2";
    sha256 = "1iyvs56x5zvvqmpr6kkamgpfj70n2rj1fh7afc7q8hj3bq7f1985";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
