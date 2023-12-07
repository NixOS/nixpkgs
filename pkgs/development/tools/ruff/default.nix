{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, rust-jemalloc-sys
  # tests
, ruff-lsp
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-Al256/8A/efLrf97xCwEocwgs3ngPnEAmkfcLWdlkTw=";
  };

  cargoHash = "sha256-4iC9pRmhxC29zIrRxQfNG3KCWtHqw8ml6MJoT/XZjSI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [ "--package=ruff_cli" ];
  cargoTestFlags = cargoBuildFlags;

  # tests expect no colors
  preCheck = ''
    export NO_COLOR=1
  '';

  postInstall = ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  passthru.tests = {
    inherit ruff-lsp;
  };

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "ruff";
    maintainers = with maintainers; [ figsoda ];
  };
}
