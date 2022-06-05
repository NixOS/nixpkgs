{ lib, stdenv, fetchFromGitHub, rustPlatform, python3Packages, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-yux5VpN8UqBscu5TyojlZmu4q2uz8b9Tu++eNlPUj/M=";
  };

  cargoSha256 = "sha256:1838dsmaqdlbd3j040bdy1fvl3z77xmcz73r11qmnqsga4yva6d7";

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
    broken = stdenv.isDarwin;
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/eqrion/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
