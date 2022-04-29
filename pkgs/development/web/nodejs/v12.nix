{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.12";
    sha256 = "1whl0zi6fs9ay33bhcn2kh9xynran05iipahg1zzr6sv97wbfhmw";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
