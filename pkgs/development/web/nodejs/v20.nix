{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.17.0";
  sha256 = "sha256-mr8DrCM2LGA4frtjOlFjA2NxRcs8F3vjNIsWiA/Ysow=";
  patches = [
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/02b30954a8a5b1f93b5e50d005c7a01b122a86ef.patch";
      hash = "sha256-3hbxVa5zRM2M3rc/YiLcdudWt32Z+LWkcHdhkUcjz24=";
    })
  ] ++ gypPatches;
}
