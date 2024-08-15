{ callPackage, lib, overrideCC, pkgs, buildPackages, openssl, python311, fetchpatch2, enableNpm ? true }:

let
  # Clang 16+ cannot build Node v18 due to -Wenum-constexpr-conversion errors.
  # Use an older version of clang with the current libc++ for compatibility (e.g., with icu).
  ensureCompatibleCC = packages:
    if packages.stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion packages.stdenv.cc.cc) "16"
      then overrideCC packages.llvmPackages_15.stdenv (packages.llvmPackages_15.stdenv.cc.override {
        inherit (packages.llvmPackages) libcxx;
      })
      else packages.stdenv;

  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    stdenv = ensureCompatibleCC pkgs;
    buildPackages = buildPackages // { stdenv = ensureCompatibleCC buildPackages; };
    python = python311;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "18.20.4";
  sha256 = "sha256-p2x+oblq62ljoViAYmDICUtiRNZKaWUp0CBUe5qVyio=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
    ./trap-handler-backport.patch
    ./use-correct-env-in-tests.patch
    ./v18-openssl-3.0.14.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/534c122de166cb6464b489f3e6a9a544ceb1c913.patch";
      hash = "sha256-4q4LFsq4yU1xRwNsM1sJoNVphJCnxaVe2IyL6AeHJ/I=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch";
      hash = "sha256-JJi8z9aaWnu/y3nZGOSUfeNzNSCYzD9dzoHXaGkeaEA=";
      includes = ["test/common/assertSnapshot.js"];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch";
      hash = "sha256-TfYal/PikRZHL6zpAlC3SmkYXCe+/8Gs83dLX/X/P/k=";
    })
  ] ++ gypPatches;
}
