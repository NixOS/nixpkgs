{ stdenv, fetchurl, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bdbbbf5980d6ec21838396a46cd5b599787e8540782b8e2e3f20d2135560a5d3";
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
    homepage = http://tmuxp.readthedocs.io;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
