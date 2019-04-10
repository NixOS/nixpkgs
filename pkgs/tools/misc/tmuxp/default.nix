{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2jmi46z1as5f7124zxjd88crbgb427jqf9987nz0csbpbb12qa";
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
