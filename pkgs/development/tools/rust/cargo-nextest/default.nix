{ lib, rustPlatform, fetchFromGitHub, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.79";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-bP7tOhmfcfAtgL5d/G/B+ZgWeE8Q7f0A09XundTrU3g=";
  };

  cargoHash = "sha256-dprzi/VRzJBBkZ3xNSYLNAnwdyY+m8wVZbyv41p6v+I=";

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}
