{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.15.1";
    sha256 = "sha256-1OmdPB9pcREJpnUlVxBY5gCc3bwijn1yO4+0pFQWm30=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
    ];
  }
