{ lib, stdenv, fetchFromGitHub, rustPlatform, python3Packages, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "sha256-BLiAFYkqVJSpeNPW7UF2PpAttd6ADGeQ9yneiVfNi4g=";
  };

  cargoSha256 = "sha256-P58qANcl0mYqJDP1QnSx560y8BLH+ePTZ+uHuix89R4=";

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
