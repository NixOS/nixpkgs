{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "18.14.2";
  sha256 = "sha256-+8Nk3SX+4srMDyAz2y2GEV/AdXUxDqDmRAi4Fw0JxoU=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
  ];
}
