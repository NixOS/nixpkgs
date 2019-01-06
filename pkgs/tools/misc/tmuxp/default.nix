{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.0a1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88b6ece3ff59a0882b5c5bff169cc4c1d688161fe61e5553b0a0802ff64b6da8";
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
    homepage = https://tmuxp.git-pull.com/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jgeerds ];
  };
}
