{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.68";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-LC+0s38ufmMrhNaKSn13jka/M7PG1+gJnqZCXJ7ef6I=";
  };

  cargoHash = "sha256-E/bsVbSdFr1LMrIewsh15Vuk4Dt5UwETLCIhE7TT3kA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

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
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}
