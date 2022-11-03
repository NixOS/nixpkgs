{ lib, fetchFromGitHub, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.42";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-tNfJJfNjaeMszO5dGBvJfq7Hb0Sxc6DbRhYvpIjpCU0=";
  };

  cargoSha256 = "sha256-wEm1ooNZGDeMwJNGGL1bPMeBqL9VjxXlKVgmshNUUoo=";

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
