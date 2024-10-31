{
  lib,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  gitpython,
  pip,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "versionfinder";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jantman";
    repo = pname;
    rev = version;
    sha256 = "16mvjwyhmw39l8by69dgr9b9jnl7yav36523lkh7w7pwd529pbb9";
  };

  propagatedBuildInputs = [
    gitpython
    backoff
  ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # Acceptance tests use the network
    "versionfinder/tests/test_acceptance.py"
  ];

  disabledTests = [
    # Tests are out-dated
    "TestFindPipInfo"
  ];

  pythonImportsCheck = [ "versionfinder" ];

  meta = with lib; {
    description = "Find the version of another package, whether installed via pip, setuptools or git";
    homepage = "https://github.com/jantman/versionfinder";
    changelog = "https://github.com/jantman/versionfinder/blob/${version}/CHANGES.rst";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
