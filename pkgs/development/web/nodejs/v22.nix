{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "22.10.0";
  sha256 = "3180710d3130ad9df01466abf010e408d41b374be54301d1480d10eca73558e0";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch

    # Patches for libuv
    # https://github.com/nodejs/node/pull/55114#issue-2547473141
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/f97865fab436fba24b46dad14435ec4b482243a2.patch?full_index=1";
      hash = "sha256-Av13UX6e21omJhHJrJCTOm/51yqcvQDng24dnkAjPqs=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/54d55f2337ebe04451da770935ad453accb147f9.patch?full_index=1";
      hash = "sha256-FGI6LiXw1WZGOEq3041wsd9XSuK6skLkZHqv6HhXC2k=";
    })
  ];
}
