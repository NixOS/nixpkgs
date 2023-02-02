{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.240";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-10pGcvMz+5obtk1lo2pg3D/VtBDhsVRsCZ+Tg1lp3qM=";
  };

  cargoSha256 = "sha256-4u05UeMw0dX0A1SjFsaUvFgPPAFbCS4POrsZuePEafc=";

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
