{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.45";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-Sb5xJCxUz60TfDMqv7Q7hTRVXvligpWkTG4FRAO/H3c=";
  };

  cargoSha256 = "sha256-LzhrPQXr+CfzNoMWrPekDvtoPn0iqLhBV+3NO5AV0Po=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  # TODO: investigate some more why these tests fail in nix
  checkFlags = [
    "--skip=tests_integration::test_list"
    "--skip=tests_integration::test_relocated_run"
    "--skip=tests_integration::test_run"
  ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda ];
  };
}
