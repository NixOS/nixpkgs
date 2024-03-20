{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-xLquursKMpV6ZELCRBrAEZ40Ypx2+vtpTVmVvOPdYS4=";
  };

  cargoHash = "sha256-F0pNAZ5ZcpGrfYt1TqtBcC2WUwjOEYf/yHero250fl0=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
