{ lib, python3Packages }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.11.0";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-N5kZ+e17ZgLOCvV/lcT/hdG1VNqLxh98QOQyM0BmZCA=";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = with pypkgs; [
    click
    colorama
    kaptan
    libtmux
  ];

  meta = with lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = "https://tmuxp.git-pull.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
