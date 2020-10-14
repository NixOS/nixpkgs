{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.13.1";
    sha256 = "1xhmdhzsk3pfl4k8l0ipd9a1v5z807sl65mwkw51y7lc44gbsqb0";
  }
