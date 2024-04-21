{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, rust-jemalloc-sys
, ruff-lsp
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-PS4YJpVut+KtEgSlTVtoVdlu6FVipPIzsl01/Io5N64=";
  };

  cargoHash = "sha256-kxzI/MlhboF0cWnyciK4vewWGXijPsOV0tPzfo1DHWc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

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
