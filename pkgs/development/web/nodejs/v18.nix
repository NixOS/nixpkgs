{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "18.17.1";
  sha256 = "sha256-8hXPA9DwDwesC2dMaBn4BMFULhbxUtoEmAAirsz15lo=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
  ];
}
