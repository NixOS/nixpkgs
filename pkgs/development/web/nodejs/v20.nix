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
  version = "20.15.1";
  sha256 = "sha256-/dU6VynZNmkaKhFRBG+0iXchy4sPyir5V4I6m0D+DDQ=";
  patches = [
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/534c122de166cb6464b489f3e6a9a544ceb1c913.patch";
      hash = "sha256-4q4LFsq4yU1xRwNsM1sJoNVphJCnxaVe2IyL6AeHJ/I=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/14863e80584e579fd48c55f6373878c821c7ff7e.patch";
      hash = "sha256-I7Wjc7DE059a/ZyXAvAqEGvDudPjxQqtkBafckHCFzo=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch";
      hash = "sha256-efRJ2nN9QXaT91SQTB+ESkHvXtBq30Cb9BEDEZU9M/8=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch";
      hash = "sha256-TfYal/PikRZHL6zpAlC3SmkYXCe+/8Gs83dLX/X/P/k=";
    })
  ] ++ gypPatches;
}
