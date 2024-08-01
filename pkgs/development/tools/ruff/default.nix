{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, rust-jemalloc-sys
, ruff-lsp
, nix-update-script
, testers
, ruff
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/${version}";
    hash = "sha256-dqfK6YdAV4cdUYB8bPE9I5FduBJ90RxUA7TMvcVq6Zw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lsp-types-0.95.1" = "sha256-8Oh299exWXVi6A39pALOISNfp8XBya8z+KT/Z7suRxQ=";
      "salsa-0.18.0" = "sha256-gcaAsrrJXrWOIHUnfBwwuTBG1Mb+lUEmIxSGIVLhXaM=";
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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  passthru.tests = {
    inherit ruff-lsp;
    updateScript = nix-update-script { };
    version = testers.testVersion { package = ruff; };
  };

  # Failing on darwin for an unclear reason.
  # According to the maintainers, those tests are from an experimental crate that isn't actually
  # used by ruff currently and can thus be safely skipped.
  checkFlags = lib.optionals stdenv.isDarwin [
    "--skip=changed_file"
    "--skip=changed_metadata"
    "--skip=deleted_file"
    "--skip=directory_deleted"
    "--skip=directory_moved_to_trash"
    "--skip=directory_moved_to_workspace"
    "--skip=directory_renamed"
    "--skip=move_file_to_trash"
    "--skip=move_file_to_workspace"
    "--skip=new_file"
    "--skip=new_ignored_file"
    "--skip=rename_file"
    "--skip=search_path"
  ];

  meta = {
    description = "Extremely fast Python linter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
    maintainers = with lib.maintainers; [
      figsoda
      GaetanLepage
    ];
  };
}
