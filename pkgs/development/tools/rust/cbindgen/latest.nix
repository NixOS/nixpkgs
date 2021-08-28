{ lib, stdenv, fetchFromGitHub, rustPlatform, python3Packages, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "0753dklr5lm1dmk6hy5khh8k3xyr5srfsq11l07685h71j7z0r00";
  };

  cargoSha256 = "0qyw0iqin7i31kk23ddsmywk7z0xxpd5n4q6dr6mf44y35a8krm8";

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
    maintainers = with maintainers; [ jtojnar ];
  };
}
