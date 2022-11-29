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
    sha256 = "sha256-PbldbKcolXvwkLYwGnqdLYBxSyoG2Jih22XG5Csdp6w=";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
