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
  version = "0.0.292";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4D7p5ZMdyemDBaWcCO62bhuPPcIypegqP0YZeX+GJRQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libcst-0.1.0" = "sha256-f4lR1vf0iL6WS7yXUzWUt/tax+xjU6rylG1EgeLex88=";
      "unicode_names2-0.6.0" = "sha256-eWg9+ISm/vztB0KIdjhq5il2ZnwGJQCleCYfznCI3Wg=";
    };
  };

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
