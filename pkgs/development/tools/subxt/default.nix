{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-13zPRp5lzUkQEcNpME1M8VMON0mq7VMQ90WL24fzcaI=";
  };

  cargoHash = "sha256-7agdxuEVLZg1uTKyrtPnLdzMHlvdY41/w6QCDj7TC2E=";

  # Only build the command line client
  cargoBuildFlags = [
    "--bin"
    "subxt"
  ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC.";
    mainProgram = "subxt";
    license = with licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
