<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.29.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MiXG4MVzomyc4LjovPsvhmPngtJv85s6Ypo/Cm2Whho=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
    python3Packages.shtab
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
=======
{ lib, python3Packages, installShellFiles }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.27.0";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-QAk+rcNYjhAgkJX2fa0bl3dHrB4yyYQ/oNlUX3IQMR8=";
  };

  # No tests in archive
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with pypkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    click
    colorama
    kaptan
    libtmux
  ];

<<<<<<< HEAD
  # No tests in archive
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(shtab --shell=bash -u tmuxp.cli.create_parser) \
      --zsh <(shtab --shell=zsh -u tmuxp.cli.create_parser)
=======
  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(_TMUXP_COMPLETE=bash_source $out/bin/tmuxp) \
      --fish <(_TMUXP_COMPLETE=fish_source $out/bin/tmuxp) \
      --zsh <(_TMUXP_COMPLETE=zsh_source $out/bin/tmuxp)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
