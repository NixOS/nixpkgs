{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.10";
    sha256 = "sha256-rUyIkdVKLJu2r0NpVt7q1ZhrlpiwbmxtYW3kKc+1OTo=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
