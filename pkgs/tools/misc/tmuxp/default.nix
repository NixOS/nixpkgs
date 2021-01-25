{ lib, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5135d07a8944170e39ea8b96b09123c54648cca94537b4953d8f15e5a537da2";
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
