{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "22.13.1";
  sha256 = "cfce282119390f7e0c2220410924428e90dadcb2df1744c0c4a0e7baae387cc2";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch

    # Those reverts are due to a mismatch with the libuv version used upstream
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/84fe809535b0954bbfed8658d3ede8a2f0e030db.patch?full_index=1";
      hash = "sha256-C1xG2K9Ejofqkl/vKWLBz3vE0mIPBjCdfA5GX2wlS0I=";
      revert = true;
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/dcbc5fbe65b068a90c3d0970155d3a68774caa38.patch?full_index=1";
      hash = "sha256-Q7YrooolMjsGflTQEj5ra6hRVGhMP6APaydf1MGH54Q=";
      revert = true;
      excludes = [ "doc/*" ];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/ec867ac7ce4e4913a8415eda48a7af9fc226097d.patch?full_index=1";
      hash = "sha256-zfnHxC7ZMZAiu0/6PsX7RFasTevHMETv+azhTZnKI64=";
      revert = true;
      excludes = [ "doc/*" ];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/f97865fab436fba24b46dad14435ec4b482243a2.patch?full_index=1";
      hash = "sha256-o5aPQqUXubtJKMX28jn8LdjZHw37/BqENkYt6RAR3kY=";
      revert = true;
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/54d55f2337ebe04451da770935ad453accb147f9.patch?full_index=1";
      hash = "sha256-gmIyiSyNzC3pClL1SM2YicckWM+/2tsbV1xv2S3d5G0=";
      revert = true;
    })
    # FIXME: remove after a minor point release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/49acdc8748fe9fe83bc1b444e24c456dff00ecc5.patch?full_index=1";
      hash = "sha256-iK7bj4KswTeQ9I3jJ22ZPTsvCU8xeGGXEOo43dxg3Mk=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0ff34f4b690ad49c86b6df8fd424f39d183e1a6.patch?full_index=1";
      hash = "sha256-ezcCrg7UwK091pqYxXJn4ay9smQwsrYeMO/NBE7VaM8=";
    })
    # test-icu-env is failing on ICU 74.2
    # FIXME: remove once https://github.com/nodejs/node/pull/56661 is included in a next release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/a364ec1d1cbbd5a6d20ee54d4f8648dd7592ebcd.patch?full_index=1";
      hash = "sha256-EL1NgCBzz5O1spwHgocLm5mkORAiqGFst0N6pc3JvFg=";
      revert = true;
    })
  ];
}
