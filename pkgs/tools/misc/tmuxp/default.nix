{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c305fc45bbf1093561e03cdcd37b2ab1f2efb9e208e74b2dc294cf414859bd8a";
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
