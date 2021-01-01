{ callPackage, openssl, python3, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.9.0";
    sha256 = "1xkfivr0qci50ksg66szyasdlbiwh2j7ia4n6qc5csih2nvzcbh1";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
