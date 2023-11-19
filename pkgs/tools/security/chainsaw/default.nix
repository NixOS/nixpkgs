{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-IBMMZ4NKD7BR3l06C7Y7pRL+pB8p6Ssx6RoXlH2XKyg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
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
