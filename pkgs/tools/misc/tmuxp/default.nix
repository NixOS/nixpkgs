{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "feec0be98a60c8cd8557bce388156202496dd9c8998e6913e595e939aeb0f735";
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
