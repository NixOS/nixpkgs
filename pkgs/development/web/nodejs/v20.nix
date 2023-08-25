{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "20.5.1";
  sha256 = "sha256-Q5xxqi84woYWV7+lOOmRkaVxJYBmy/1FSFhgScgTQZA=";
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
  ];
}
