{ lib, buildPythonPackage, fetchFromGitHub, GitPython, pytest, backoff, requests }:

buildPythonPackage rec {
  pname = "versionfinder";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jantman";
    repo = pname;
    rev = version;
    sha256 = "16mvjwyhmw39l8by69dgr9b9jnl7yav36523lkh7w7pwd529pbb9";
  };

  propagatedBuildInputs = [
    GitPython
    backoff
  ];

  checkInputs = [
    pytest
    requests
  ];

  pythonImportsCheck = [ "versionfinder" ];

  meta = with lib; {
    description = "Find the version of another package, whether installed via pip, setuptools or git";
    homepage = "https://github.com/jantman/versionfinder";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
