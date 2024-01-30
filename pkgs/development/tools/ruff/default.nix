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
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-DzdzMO9PEwf4HmpG8SxRJTmdrmkXuQ8RsIchvsKstH8=";
  };

  # The following specific substitution is not working as the current directory is `/build/source` and thus has no mention of `ruff` in it.
  # https://github.com/astral-sh/ruff/blob/866bea60a5de3c59d2537b0f3a634ae0ac9afd94/crates/ruff/tests/show_settings.rs#L12
  # -> Just patch it so that it expects the actual current directory and not `"[BASEPATH]"`.
  postPatch = ''
    substituteInPlace crates/ruff/tests/snapshots/show_settings__display_default_settings.snap \
      --replace '"[BASEPATH]"' '"'$PWD'"'
  '';

  cargoHash = "sha256-MpiWdNUs66OGYfOJo1kJQTCqjrk/DAYecaLf6GUUKew=";

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
