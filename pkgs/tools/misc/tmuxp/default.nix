{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hy21qa80namd2s6zqhf1wkn7f7dpp59sbr32726nl5vi9n566fx";
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
