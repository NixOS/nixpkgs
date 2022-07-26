{ lib, fetchFromGitHub, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.26";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-/ij0SOuBJ3nTiv2YZCTTcTluYehkUj7Ks3t5F2mRNcM=";
  };

  cargoSha256 = "sha256-HeTJKzKVkgxJ/04ry7plKdENdjzC7VpCQwGz5MXXTFY=";

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
