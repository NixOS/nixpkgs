{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13qnacqlcih731wfrsalbff1g81inkh6sypvabg5gi7gd7mha49p";
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
