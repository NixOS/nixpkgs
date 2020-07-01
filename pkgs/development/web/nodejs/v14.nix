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
    version = "14.5.0";
    sha256 = "1d6w7ycdiqbkip7m6m8xly31qgx7ywakzvrnqdq8ini5sricjlgb";
  }
