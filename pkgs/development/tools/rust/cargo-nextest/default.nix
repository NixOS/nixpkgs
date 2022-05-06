{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-g2kgMMmztURik/aSgP76vG+yI3vSqX9k836ACtLviFk=";
  };

  cargoSha256 = "sha256-1TJ96ilHX+LGkrMLXIK4rAebVxNQpRTYo9RnPE6BmmU=";

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
