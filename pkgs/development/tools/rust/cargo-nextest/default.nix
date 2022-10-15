{ lib, fetchFromGitHub, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.38";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-gBYtO9lnxtrgn5cmmgPeaFQ2Ls3WSO9X4RwDBHKbRO8=";
  };

  cargoSha256 = "sha256-Xz5X2I4Lj4lPv18vYjambdlwcRcbHKAbjqPpSuei96Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoTestFlags = [ # TODO: investigate some more why these tests fail in nix
    "--"
    "--skip=tests_integration::test_relocated_run"
    "--skip=tests_integration::test_run"
    "--skip=tests_integration::test_run_after_build"
  ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    homepage = "https://github.com/nextest-rs/nextest";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
  };
}
