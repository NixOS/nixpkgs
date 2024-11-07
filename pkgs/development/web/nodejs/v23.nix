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
  version = "23.1.0";
  sha256 = "57cbfd3dd51f9300ea2b8e60a8ed215b1eaa71fbde4c3903a7d31a443a4a4423";
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
  ];
}
