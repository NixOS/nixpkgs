{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.17.1";
  sha256 = "sha256-8hXPA9DwDwesC2dMaBn4BMFULhbxUtoEmAAirsz15lo=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
    ./trap-handler-backport.patch
    # Fixes target toolchain arguments being passed to the host toolchain when
    # cross-compiling. For example, -m64 is not available on aarch64.
    (fetchpatch {
      name = "common-gypi-cross.patch";
      url = "https://github.com/nodejs/node/pull/48597.patch";
      hash = "sha256-FmHmwlTxPw5mTW6t4zuy9vr4FxopjU4Kx+F1aqabG1s=";
    })
  ];
}
