{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-LDhC/vwhyY4KD1RArCxl+nZl5IVj0zAjxlRLwWpnTvI=";
  };

  cargoHash = "sha256-vygAznYd/mtArSkLjoIpIxS4RiE3drRfKwNhD1w7KoY=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A Cargo tool that detects unused dependencies in Rust projects";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
