{ callPackage, openssl, python3, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.15.3";
    sha256 = "1zplrfhsrqblvq2wxf5386wc9hf11k42jaw4mzgwy5dxx6dv3krj";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
