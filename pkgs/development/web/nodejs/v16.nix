{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.15.1"; # Do not upgrade until #176127 is solved
    sha256 = "0zcv2raa9d4g7dr7v3i2pkfrq076b085f9bmlq4i2wb93wy9vsfl";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
    ];
  }
