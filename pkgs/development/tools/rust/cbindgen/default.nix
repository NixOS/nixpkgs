{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, python3Packages
, Security

# tests
, firefox-unwrapped
, firefox-esr-unwrapped
, mesa
, fetchpatch2
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-XTGHHD5Qw3mr+lkPKOXyqb0K3sEENW8Sf0n9mtrFFXI=";
  };

  patches = [
    (fetchpatch2 {
      # merged upstream: https://github.com/mozilla/cbindgen/pull/1010
      name = "1010-fix-test-failures-due-to-CARGO_BUILD_TARGET";
      url = "https://github.com/mozilla/cbindgen/compare/dce986b8d0a0aac266ebdf2298274844362c56fb...d8432dbc35887952e72eb5d7c62e5dbe3c4b29ff.diff";
      # ^ using .diff to provide a minimal patch
      # ... note that `?full_index=1` does not work with commit ranges
      hash = "sha256-lrMSyRhBK3DZ9PKKW85k7vqlsBUTHn4G1013bVWnbNU=";
    })
  ];

  cargoHash = "sha256-l4FgwXdibek4BAnqjWd1rLxpEwuMNjYgvo6X3SS3fRo=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  nativeCheckInputs = [
    cmake
    python3Packages.cython
  ];

  checkFlags = [
    # Disable tests that require rust unstable features
    # https://github.com/eqrion/cbindgen/issues/338
    "--skip test_expand"
    "--skip test_bitfield"
    "--skip lib_default_uses_debug_build"
    "--skip lib_explicit_debug_build"
    "--skip lib_explicit_release_build"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # WORKAROUND: test_body fails when using clang
    # https://github.com/eqrion/cbindgen/issues/628
    "--skip test_body"
  ];

  passthru.tests = {
    inherit
      firefox-unwrapped
      firefox-esr-unwrapped
      mesa
    ;
  };

  meta = with lib; {
    changelog = "https://github.com/mozilla/cbindgen/blob/v${version}/CHANGES";
    description = "Project for generating C bindings from Rust code";
    mainProgram = "cbindgen";
    homepage = "https://github.com/mozilla/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
