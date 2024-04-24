{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.28";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RpMOtgLp9cvXr8lNqGmLvCSbBt7tt7au8hhDCaSERRo=";
  };

  cargoHash = "sha256-KpG+T1rI14BgvWvRqiZ5y/n9+J1YRj4+j556zaY7aUA=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
