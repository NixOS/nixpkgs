{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.15.0";
    sha256 = "sha256-oPgS78Q/eDIeygiVeWCkj15r+XAE1QWMjdOwPGRupPc=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
    ];
  }
