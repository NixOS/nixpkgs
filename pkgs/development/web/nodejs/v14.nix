{ callPackage, python3, lib, stdenv, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.21.1";
    sha256 = "1b573lmy9ik5vfhrin06595p301dkmx1lc5nj3q7p598lxn5vf9x";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
