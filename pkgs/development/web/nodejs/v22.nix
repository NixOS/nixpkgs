{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.9.0";
  sha256 = "a55aeb368dee93432f610127cf94ce682aac07b93dcbbaadd856df122c9239df";
  patches = [
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch
  ] ++ gypPatches;
}
