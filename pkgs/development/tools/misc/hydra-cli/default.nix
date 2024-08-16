{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  testers,
  hydra-cli,
}:

rustPlatform.buildRustPackage rec {
  pname = "hydra-cli";
  version = "0.3.0-unstable-2023-12-20";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = "hydra-cli";
    rev = "dbb6eaa45c362969382bae7142085be769fa14e6";
    hash = "sha256-6L+5rkXzjXH9JtLsrJkuV8ZMsm64Q+kcb+2pr1coBK4=";
  };

  sourceRoot = "${src.name}/hydra-cli";

  cargoHash = "sha256-WokdTMNA7MrbFcKNeFIRU2Tw6LyM80plDoZPX1v/hrc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = hydra-cli;
    version = "0.3.0";
  };

  meta = {
    description = "Client for the Hydra CI";
    mainProgram = "hydra-cli";
    homepage = "https://github.com/nlewo/hydra-cli";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      lewo
      aleksana
    ];
  };
}
