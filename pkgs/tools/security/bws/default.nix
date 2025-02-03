{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
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
    installShellFiles
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    perl
  ];

  buildInputs =
    [
      oniguruma
    ] ++ lib.optionals stdenv.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  cargoBuildFlags = [ "--package" "bws" ];

  cargoTestFlags = [ "--package" "bws" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bws \
      --bash <($out/bin/bws completions bash) \
      --fish <($out/bin/bws completions fish) \
      --zsh <($out/bin/bws completions zsh)
  '';

  meta = {
    changelog = "https://github.com/bitwarden/sdk/blob/${src.rev}/crates/bws/CHANGELOG.md";
    description = "Bitwarden Secrets Manager CLI";
    homepage = "https://bitwarden.com/help/secrets-manager-cli/";
    license = lib.licenses.unfree; # BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT
    mainProgram = "bws";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
