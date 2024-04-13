{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    hash = "sha256-45jQt5VK7h02Frz5urB6dXap796OTfHsPx/Q1xumM00=";
  };

  cargoHash = "sha256-+AKgEyKer9S2lTUF3VA4UXnbR0nUBErp2OdqFC84W00=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda hugoreeves ];
  };
}
