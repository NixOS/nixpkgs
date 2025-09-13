{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "buildkite-test-collector-rust";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "test-collector-rust";
    rev = "v${version}";
    sha256 = "sha256-PF2TFfzWmHXLgTopzJ04dfnzd3Sc/A6Hduffz2guxmU=";
  };

  cargoHash = "sha256-jymWM0DCR6jUE1Kyhbx6HHf6YlrGu1THKTyDHaPG+Vs=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Rust adapter for Buildkite Test Analytics";
    mainProgram = "buildkite-test-collector";
    homepage = "https://buildkite.com/test-analytics";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jfroche ];
  };
}
