{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pest-ide-tools";
  version = "0.3.9";
  cargoSha256 = "sha256-kFLVzsk2ML78zWoLVX/tPz+rwBPziXmfGAcVSA7GiTA=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${version}";
    sha256 = "sha256-6051J3DQjI+Wp3iLn65GRmMnwOjGEtcWyXEKsT9k9fE=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "IDE support for Pest, via the LSP.";
    homepage = "https://pest.rs";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
}
