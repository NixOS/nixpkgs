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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-khi5B8nYNK7otWZEs5koCzQaYGZwmGxP3zrMYIt3Ds4=";
  };

  cargoHash = "sha256-IHGl+Lxa9ZKlyXp59mv72QIvC3hkXPFOUKPVYbN50W4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
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
