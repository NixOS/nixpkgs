{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${version}";
    hash = "sha256-5D3wojKFYL+hOwroe0grAQ524uOVI6fn1ENcP7IEEeA=";
  };

  cargoHash = "sha256-89cPYlQy3PUl1uTJSUMVgTaFX6dmY9Iwut507VzyDoM=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rpaste";
  };
}
