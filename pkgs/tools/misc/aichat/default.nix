{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-1m0Sf8qC5kGOfXkxQVri+kL3sZfOFKH3TcpNhuOFPVQ=";
  };

  cargoHash = "sha256-/oEyI6m5j3u89NeEwM4+z1exZfu0FMSf14scAiax3CE=";

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
