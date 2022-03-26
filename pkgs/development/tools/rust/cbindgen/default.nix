{ lib, stdenv, fetchFromGitHub, rustPlatform, python3Packages, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "sha256-WvCGAjFxjaql/y35QfHyHvwbEL4pKtlc3JO2NecqQCM=";
  };

  cargoSha256 = "sha256-Kl2/u+ttPn1k7f3+XRCord4u+c4QZ80/Okb40XeyeIk=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  checkInputs = [
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
  ];

  meta = with lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/eqrion/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
