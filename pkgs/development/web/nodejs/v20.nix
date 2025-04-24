{
  lib,
  stdenv,
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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    # Fix builds with shared llhttp
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/ff3a028f8bf88da70dc79e1d7b7947a8d5a8548a.patch?full_index=1";
      hash = "sha256-LJcO3RXVPnpbeuD87fiJ260m3BQXNk3+vvZkBMFUz5w=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/4454d09e8f7225ec1b576ef86c8705bca63a136c.patch?full_index=1";
      hash = "sha256-M6eme92cY1dhu1I5/v7Tcd3iSlQi5ZeC48qwLoYj2iA=";
    })
    # update tests for nghttp2 1.65
    ./deprecate-http2-priority-signaling.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/a63126409ad4334dd5d838c39806f38c020748b9.diff?full_index=1";
      hash = "sha256-lfq8PMNvrfJjlp0oE3rJkIsihln/Gcs1T/qgI3wW2kQ=";
      includes = [ "test/*" ];
    })
  ]
  ++ gypPatches;
}
