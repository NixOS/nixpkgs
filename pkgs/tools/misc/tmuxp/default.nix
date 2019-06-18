{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vxnq5r3h32dvznh4lal29q5ny70rd861r7435gn7sa6v5ajs2f1";
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
    maintainers = with maintainers; [ ];
  };
}
