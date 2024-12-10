{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ezno";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "kaleidawave";
    repo = "ezno";
    rev = "release/ezno-${version}";
    hash = "sha256-0yLEpNkl7KjBEGxNONtfMjVlWMSKGZ6TbYJMsCeQ3ms=";
  };

  cargoHash = "sha256-noMfKx6BsmWhAVI4r8LlC961Uwogv1JGMYSrNGlLGPQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [
    "--bin"
    "ezno"
  ];

  meta = with lib; {
    description = "A JavaScript compiler and TypeScript checker with a focus on static analysis and runtime performance";
    mainProgram = "ezno";
    homepage = "https://github.com/kaleidawave/ezno";
    changelog = "https://github.com/kaleidawave/ezno/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
