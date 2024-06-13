{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-V7WKzi9PKSek8DlF7QzBEaYn3a+BJzMtKEoi5yMGS/w=";
  };

  cargoHash = "sha256-sFRYu1sQ9PdjsBTgajMfvJqA32Q8HZCHs3h2wemb9oY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = licenses.mit;
    maintainers = with maintainers; [ mwdomino ];
    mainProgram = "aichat";
  };
}
