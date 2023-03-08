{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "18.15.0";
  sha256 = "sha256-jkTWUBj/lzKEGVwjGGRpoOpAgul+xCAOX1cG1VhNqjc=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
  ];
}
