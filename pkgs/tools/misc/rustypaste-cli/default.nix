{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${version}";
    hash = "sha256-lMXd/wllk/67W3dJr/ps36s/p+tMCyu2HU9gWYubejw=";
  };

  cargoHash = "sha256-6ddjSP072+jYjPVcTZcQndM1pElUE30hU3M/sf5Lnsk=";

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
