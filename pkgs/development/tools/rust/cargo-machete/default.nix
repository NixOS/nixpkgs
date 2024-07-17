{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-8ktiBnlcnC4QD3rIox8rfxhF0ZWOlbok8rK7fnqeZOM=";
  };

  cargoHash = "sha256-emW/TDpeh/7hgqTgXAZeQwzkSIktDxk3Lp3JyhdTSRo=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
