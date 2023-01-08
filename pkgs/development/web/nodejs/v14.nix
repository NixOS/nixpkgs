{ callPackage, python3, lib, stdenv, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.21.2";
    sha256 = "00zzl43iis8mr8x48hww5ncj8mj5dmpn05rq7ihpffkp2q7rmw6q";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
