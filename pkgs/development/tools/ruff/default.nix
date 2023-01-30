{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.237";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c2mD03gxbBnnifTXPpdJk4kwpeHdrwckymaFGKJwDc8=";
  };

  cargoSha256 = "sha256-pYOMCmNrI4uzqXkbc2D9UvNHg2PlibmEhtml+A1V1BQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

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
