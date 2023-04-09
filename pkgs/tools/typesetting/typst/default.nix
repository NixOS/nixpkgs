{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-fPcQlgmpViDsvd9OmnP1wZoMTOtyL5pfH6plktNG0JQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://typst.app";
    changelog = "https://github.com/typst/typst/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol figsoda kanashimia ];
  };
}
