{ lib, python3Packages, fetchPypi, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.39.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E8Q1uCV3kl4rYg/bzwjk3CNQU/uP9lEZzSqcOFkLrY0=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
    python3Packages.shtab
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    kaptan
    libtmux
  ];

  # No tests in archive
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(shtab --shell=bash -u tmuxp.cli.create_parser) \
      --zsh <(shtab --shell=zsh -u tmuxp.cli.create_parser)
  '';

  meta = with lib; {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg otavio ];
    mainProgram = "tmuxp";
  };
}
