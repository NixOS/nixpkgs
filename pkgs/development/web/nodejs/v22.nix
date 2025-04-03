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
in
buildNodejs {
  inherit enableNpm;
  version = "22.14.0";
  sha256 = "c609946bf793b55c7954c26582760808d54c16185d79cb2fb88065e52de21914";
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
      hash = "sha256-OQwtp/5BI9M0++d1cg0Dt/7jLH5fJEOYQRPivILKRPk=";
      revert = true;
      excludes = [
        "doc/*"
        "test/common/net.js"
      ];
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
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/869d0cbca3b0b5e594b3254869a34d549664e089.patch?full_index=1";
      hash = "sha256-BBBShQwU20TSY8GtPehQ9i3AH4ZKUGIr8O0bRsgrpNo=";
      revert = true;
    })
  ];
}
