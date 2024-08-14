{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.4.1";
  sha256 = "sha256-ZfyFf1qoJWqvyQCzRMARXJrq4loCVB/Vzg29Tf0cX7k=";
  patches = [
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch
  ] ++ gypPatches;
}
