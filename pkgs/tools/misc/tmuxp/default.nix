{ lib, python3Packages, fetchPypi, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sNLqUyas6QY11eW/FhkqB6+u4MTqiY1ixvD3BN69Fic=";
  };

  # No tests in archive
  doCheck = false;

  format = "pyproject";

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
    maintainers = with maintainers; [ peterhoeg ];
  };
}
