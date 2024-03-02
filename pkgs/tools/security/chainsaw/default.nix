{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "chainsaw";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    rev = "refs/tags/v${version}";
    hash = "sha256-YEw/rN7X+npc9M8XdPGAZyYXSQOGiR0w9Wb3W63g8VU=";
  };

  cargoHash = "sha256-cXvXvSipZFfanmn9QFtYZYEudZ6lyvsu2EMGD0lZEtw=";

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
