{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-gUn1NnEbiZbg7zBer1KX8smBCpcL0fQ+TkEoH8kdPws=";
  };

  cargoHash = "sha256-xbWcH8kkDe3+IEeHqxd8QW1h5oPDJfAkfNzJp8MWLR8=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installShellCompletion ./scripts/completions/aichat.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = licenses.mit;
    maintainers = with maintainers; [ mwdomino ];
    mainProgram = "aichat";
  };
}
