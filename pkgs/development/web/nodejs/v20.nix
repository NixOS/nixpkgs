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
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.19.4";
  sha256 = "b87fd7106013d3906706913ffc63a4403715fbb272c4f83ff4338527353eec0f";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch

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
