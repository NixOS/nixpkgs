{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-rItLlyYUQODFazdVhCdAQgrrF8K2Cjuhyt5pvRyhSro=";
  };

  cargoHash = "sha256-sY4gXzMn7LTpJ/22BNKbmlHUbEx/CqS2+wa8DfLr/Fw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
