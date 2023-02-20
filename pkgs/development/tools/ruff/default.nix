{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.248";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qsjn8AW6Wx0ZaTht9BToQxYWngrrrR8LIIWcNfr8fXw=";
  };

  # We have to use importCargoLock here because `cargo vendor` currently doesn't support workspace
  # inheritance within Git dependencies, but importCargoLock does.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libcst-0.1.0" = "sha256-66Td5jnLEEDHgYapsSmxfgIE43T7PSTYRznllIOw81U=";
      "rustpython-ast-0.2.0" = "sha256-k2WHnRtqSzdawHQKOfTjvyZxgRWXRv9dvSzfYC7171o=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [ "--package=ruff_cli" ];

  # building tests fails with `undefined symbols`
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    changelog = "https://github.com/charliermarsh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
