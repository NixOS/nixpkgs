{ lib, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14296b62db260420d4600dcd805408ea908b3a78d4ea0a6a403d092fdbf6d075";
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

  meta = with lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = "https://tmuxp.git-pull.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
