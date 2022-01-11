{ lib, buildPythonPackage, fetchFromGitHub, GitPython, pytestCheckHook, backoff, requests }:

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
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # acceptance tests use the network
    "versionfinder/tests/test_acceptance.py"
  ];

  pythonImportsCheck = [ "versionfinder" ];

  meta = with lib; {
    description = "Find the version of another package, whether installed via pip, setuptools or git";
    homepage = "https://github.com/jantman/versionfinder";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
