{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-9UmyHf2aH6ODGEbsDBBD8pLRkRtOpc9HGKp9UV7mk0o=";
  };

  cargoHash = "sha256-f4EDtRFjRU62Nuzaq5EbL+/sCKyMMgSOu6MaFsuAFec=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreFoundation ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Rapidly Search and Hunt through Windows Forensic Artefacts";
    homepage = "https://github.com/WithSecureLabs/chainsaw";
    changelog = "https://github.com/WithSecureLabs/chainsaw/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "chainsaw";
  };
}
