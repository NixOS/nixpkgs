{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste-cli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${version}";
    hash = "sha256-Nx0mnwoyJlZSaOiGsqhrx6o9ZDJAGbEpOBhPknbZBjI=";
  };

  cargoHash = "sha256-z/llEeUfiWPCy8JspmpbbX0FCb8eXPvV1SJAW7ujSyU=";

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
