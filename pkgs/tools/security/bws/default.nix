{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, openssl
, stdenv
, darwin
, python3
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "bws";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "bws-v${version}";
    hash = "sha256-oCAyUTVAUfXBEb2K7vkYBOzcwqCsm2wxEKsYLZcfm6w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "uniffi-0.25.2" = "sha256-YckrtociJV3VKGs5DJ0a1r1Cvq06S/mtr9iL1kLmAi8=";
    };
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  buildAndTestSubdir = "crates/bws";

  meta = {
    changelog = "https://github.com/bitwarden/sdk/blob/${src.rev}/CHANGELOG.md";
    description = "Bitwarden Secrets Manager CLI";
    homepage = "https://github.com/bitwarden/sdk";
    license = lib.licenses.unfree; # BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT
    mainProgram = "bws";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
