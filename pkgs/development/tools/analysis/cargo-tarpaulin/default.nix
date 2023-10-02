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
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    hash = "sha256-Mr1thOGqpLcMUBbmD6YzU9WlyOvlPHSqyiU/wtb4edo=";
  };

  cargoHash = "sha256-UrDyAS/SIrXWsYucmjj6URjqjjWB40wxLF0rXHmB2Tw=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda hugoreeves ];
  };
}
