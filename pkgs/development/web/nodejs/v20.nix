{
  callPackage,
  fetchpatch2,
  openssl,
  python3,
  enableNpm ? true,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    # Fixes builds with Nix sandbox on Darwin for gyp.
    # See https://github.com/NixOS/nixpkgs/issues/261820
    # and https://github.com/nodejs/gyp-next/pull/216
    (fetchpatch2 {
      url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch?full_index=1";
      hash = "sha256-iV9qvj0meZkgRzFNur2v1jtLZahbqvSJ237NoM8pPZc=";
      stripLen = 1;
      extraPrefix = "tools/gyp/";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch?full_index=1";
      hash = "sha256-1iyeeAprmWpmLafvOOXW45iZ4jWFSloWJxQ0reAKBOo=";
      stripLen = 1;
      extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
    })

    ./gyp-patches-pre-v22-import-sys.patch
    ./gyp-patches-set-fallback-value-for-CLT.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.19.5";
  sha256 = "230c899f4e2489c4b8d2232edd6cc02f384fb2397c2a246a22e415837ee5da51";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./use-nix-codesign.patch

    # TODO: remove when included in a release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/8caa1dcee63b2c6fd7a9edf9b9a6222b38a2cf62.patch?full_index=1";
      hash = "sha256-DtN0bpYfo5twHz2GrLLgq4Bu2gFYTkNPMRKhrgeYRyA=";
      includes = [ "test/parallel/test-setproctitle.js" ];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/499a5c345165f0d4a94b98d08f1ace7268781564.patch?full_index=1";
      hash = "sha256-wF4+CytC1OB5egJGOfLm1USsYY12f9kADymVrxotezE=";
    })
  ]
  ++ gypPatches;
}
