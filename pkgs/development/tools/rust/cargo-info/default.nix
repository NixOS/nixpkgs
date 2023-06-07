{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-info";
  version = "0.7.3";

  src = fetchFromGitLab {
    owner = "imp";
    repo = "cargo-info";
    rev = version;
    hash = "sha256-m8YytirD9JBwssZFO6oQ9TGqjqvu1GxHN3z8WKLiKd4=";
  };

  cargoHash = "sha256-gI/DGPCVEi4Mg9nYLaPpeqpV7LBbxoLP0ditU6hPS1w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cargo subcommand to show crates info from crates.io";
    homepage = "https://gitlab.com/imp/cargo-info";
    changelog = "https://gitlab.com/imp/cargo-info/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
