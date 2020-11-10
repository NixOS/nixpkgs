{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09b403c9e1ef50695fab1e72376ff5674906b485fbcaad50c7cafec1ba775087";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements/base.txt requirements/test.txt
  '';

  checkInputs = [
    pytest
    pytest-rerunfailures
  ];

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [
    click colorama kaptan libtmux
  ];

  meta = with stdenv.lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = "https://tmuxp.git-pull.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
