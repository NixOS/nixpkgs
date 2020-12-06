{ callPackage, openssl, python3, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.15.1";
    sha256 = "1g61vqsgq3jsipw2fckj68i4a4pi1iz1kbw7mlw8jmzp8rl46q81";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
