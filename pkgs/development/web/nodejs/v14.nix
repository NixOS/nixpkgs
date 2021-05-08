{ callPackage, openssl, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.16.1";
    sha256 = "1hxsk83g2plv6vv3ir1ngca0rwqdy3lq70r504d2qv3msszdnjp4";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
