{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
, stdenv
, darwin
, rust-jemalloc-sys
, ruff-lsp
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-VcDDGi6fPGZ75+J7aOSr7S6Gt5bpr0vM2Sk/Utlmf4k=";
  };

  patches = [
    # TODO: remove at next release
    (fetchpatch {
      name = "filter-out-test-rules-in-ruleselector-json-schema";
      url = "https://github.com/astral-sh/ruff/commit/49c5e715f9c85aa8d0412b2ec9b1dd6f7ae24c5c.patch";
      hash = "sha256-s0Nv5uW3TKfKgro3V3E8Q0c8uOTgOKZQx9CxXge4YWE=";
    })
  ];

  # The following specific substitution is not working as the current directory is `/build/source` and thus has no mention of `ruff` in it.
  # https://github.com/astral-sh/ruff/blob/866bea60a5de3c59d2537b0f3a634ae0ac9afd94/crates/ruff/tests/show_settings.rs#L12
  # -> Just patch it so that it expects the actual current directory and not `"[BASEPATH]"`.
  postPatch = ''
    substituteInPlace crates/ruff/tests/snapshots/show_settings__display_default_settings.snap \
      --replace '"[BASEPATH]"' '"'$PWD'"'
  '';

  cargoHash = "sha256-B7AiDNWEN4i/Lz9yczlRNXczQph52SMa3pcxK2AtO2A=";

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
