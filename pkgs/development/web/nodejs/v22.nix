{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./patches/gyp-patches-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.5.1";
  sha256 = "924f381a32cf26b6bedbe95feedde348450f4fd321283d3bf3f7965aa45ce831";
  patches = [
    ./patches/configure-emulator.patch
    ./patches/configure-armv6-vfpv2.patch
    ./patches/disable-darwin-v8-system-instrumentation-node19.patch
    ./patches/bypass-darwin-xcrun-node16.patch
    ./patches/node-npm-build-npm-package-logic.patch
    ./patches/use-correct-env-in-tests.patch
    ./patches/bin-sh-node-run-v22.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch";
      hash = "sha256-TfYal/PikRZHL6zpAlC3SmkYXCe+/8Gs83dLX/X/P/k=";
    })
  ] ++ gypPatches;
}
