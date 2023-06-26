{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.54";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-HkDGW91XDoYMfknPg6td51KTYniCfGtGQd3dkzumRpo=";
  };

  cargoHash = "sha256-McL5G/PtdOou17hWLiNTSJEjTh4YpT1GUPjTMAVNxQA=";

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
