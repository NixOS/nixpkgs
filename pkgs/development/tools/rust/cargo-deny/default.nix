{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.14.18";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-aVWr7YXGpRDItub4CaUg9LYxj9Nf0Pe1L0FUr9bJoG0=";
  };

  cargoHash = "sha256-AD4WFM0yAIKgi9y8015qxukAa3YBJmPnkUhV7qp0quk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer jk ];
  };
}
