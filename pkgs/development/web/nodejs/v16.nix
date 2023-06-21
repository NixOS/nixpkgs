{ callPackage, openssl, python3, fetchpatch, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  npmPatches = callPackage ./npm-patches.nix { };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.20.1";
    sha256 = "sha256-g+AzgeJx8aVhkYjnrqnYXZt+EvW+KijOt41ySe0it/E=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      ./bypass-darwin-xcrun-node16.patch
      ./node-npm-build-npm-package-logic-node16.patch
    ] ++ npmPatches;
  }
