{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-plfEVVMbiTXzBhshO3NZVeuHuNeI9+Lcw1G5xeBiTks=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "notatin-1.0.0" = "sha256-eeryJhH7kX8QWwVuEq5RzanVT2FBfFJWAzUDFgUKqR8=";
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
