{ callPackage, openssl, icu66, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    icu = icu66;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.1.0";
    sha256 = "0pw39628y8qi2jagmmnfj0fkcbv00qcd1cqybiprf1v22hhij44n";
  }
