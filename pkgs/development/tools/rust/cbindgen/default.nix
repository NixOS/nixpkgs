{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, python3Packages
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-gyNZAuxpeOjuC+Rh9jAyHSBQRRYUlYoIrBKuCFg3Hao=";
  };

  cargoSha256 = "sha256-pdTxhECAZzBx5C01Yx7y/OGwhhAdlEDpqLBdvQcb8bc=";

  buildInputs = lib.optional stdenv.isDarwin Security;

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
  ] ++ lib.optionals stdenv.isDarwin [
    # WORKAROUND: test_body fails when using clang
    # https://github.com/eqrion/cbindgen/issues/628
    "--skip test_body"
  ];

  meta = with lib; {
    changelog = "https://github.com/mozilla/cbindgen/blob/v${version}/CHANGES";
    description = "A project for generating C bindings from Rust code";
    mainProgram = "cbindgen";
    homepage = "https://github.com/mozilla/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
