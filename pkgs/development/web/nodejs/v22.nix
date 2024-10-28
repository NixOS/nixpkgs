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

    # Patch to use the shared version of SQLite instead of the one vendored upstream:
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/32f7d5ad1cf79e7e731e1bb7ac967f4f2a3194cf.patch?full_index=1";
      hash = "sha256-dyUr3caGfetrXgfAl+CLE1LKKetDZCpPwMg4EM98rqI=";
    })
  ];
}
