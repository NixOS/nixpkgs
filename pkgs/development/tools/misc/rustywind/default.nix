{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-gcSpifeOWq9kKmOqyO02DbcvR9tyTlE2kVkezpy7D5k=";
  };

  cargoHash = "sha256-m++IeB0XvfeARkh+yO9WQtc7luz+ThGD5niwwOPobKY=";

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
