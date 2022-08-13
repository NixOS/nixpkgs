{ lib, python3Packages }:

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
