{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-Et90CW1fHt6GuHgQP2nRvcS7in4zw2UgBiQhblQGM+8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "notatin-0.1.0" = "sha256-YHC/NavKf0FoYtd5NM8ovUfSd4ODhKaA82mAT+HcefA=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "Rapidly Search and Hunt through Windows Forensic Artefacts";
    homepage = "https://github.com/WithSecureLabs/chainsaw";
    changelog = "https://github.com/WithSecureLabs/chainsaw/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
