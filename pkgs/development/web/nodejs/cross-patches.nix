{ fetchpatch }:
[
  # Fixes target toolchain arguments being passed to the host toolchain when
  # cross-compiling. For example, -m64 is not available on aarch64.
  (fetchpatch {
    name = "common-gypi-cross.patch";
    url = "https://github.com/nodejs/node/pull/48597.patch";
    hash = "sha256-FmHmwlTxPw5mTW6t4zuy9vr4FxopjU4Kx+F1aqabG1s=";
  })
]
