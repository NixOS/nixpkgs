{ lib, python3Packages, installShellFiles }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.12.1";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "078624c5ac7aa4142735f856fadb9281fcebb10e6b98d1be2b2f2bbd106613b9";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "libtmux>=0.12.0,<0.13.0" "libtmux"
  '';

  # No tests in archive
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with pypkgs; [
    click
    colorama
    kaptan
    libtmux
  ];

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(_TMUXP_COMPLETE=bash_source $out/bin/tmuxp) \
      --fish <(_TMUXP_COMPLETE=fish_source $out/bin/tmuxp) \
      --zsh <(_TMUXP_COMPLETE=zsh_source $out/bin/tmuxp)
  '';

  meta = with lib; {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
