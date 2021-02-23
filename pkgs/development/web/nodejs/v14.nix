{ callPackage, openssl, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.15.5";
    sha256 = "0nv576mlmnf8pfs6yn7vsvwyg0a0xvs7m9pm4k131zjqx501v6z1";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
