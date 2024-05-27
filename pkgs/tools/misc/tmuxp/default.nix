{ lib, python3Packages, fetchPypi, installShellFiles }:

let
  pname = "tmuxp";
  version = "1.46.0";
  hash = "sha256-+aXpsB4mjw9sZLalv3knW8okP+mh2P/nbZCiCwa3UBU=";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version hash;
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
    python3Packages.shtab
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
    colorama
    libtmux
    pyyaml
  ];

  # No tests in archive
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(shtab --shell=bash -u tmuxp.cli.create_parser) \
      --zsh <(shtab --shell=zsh -u tmuxp.cli.create_parser)
  '';

  meta = {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "tmuxp";
  };
}
