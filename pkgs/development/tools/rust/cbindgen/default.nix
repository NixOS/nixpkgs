<<<<<<< HEAD
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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-gljICr0abKEXxJfLCJN3L2OIwUvw/QoIC6T5C7pieEA=";
  };

  cargoSha256 = "sha256-agBzn2MibM7158/QlLXI2HBBcYIe0p50rYSF1jBDF8U=";
=======
{ lib, stdenv, fetchFromGitHub, rustPlatform, python3Packages, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-v5g6/ul6mJtzC4O4WlNopPtFUSbx2Jv79mZL72mucws=";
  };

  cargoSha256 = "sha256-j3/2cFjSDkx0TXCaxYSCLrBbAHrJfJ6hwBcXlDedwh8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  nativeCheckInputs = [
<<<<<<< HEAD
    cmake
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/mozilla/cbindgen/blob/v${version}/CHANGES";
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/mozilla/cbindgen";
=======
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/eqrion/cbindgen";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
