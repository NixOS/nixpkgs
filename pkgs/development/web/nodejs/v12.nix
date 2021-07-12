{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.3";
    sha256 = "143ihn30jd08nk19saxn6qp3ldc9yvy8w338i4cg9256wgx120im";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
