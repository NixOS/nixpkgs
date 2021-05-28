{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jbziyqggbfd5m884lg00h0zi99c6cvjxkl4jzr34c4affr295yd";
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
