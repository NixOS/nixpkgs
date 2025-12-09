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
  setuptools,
}:

buildPythonPackage rec {
  pname = "versionfinder";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jantman";
    repo = "versionfinder";
    rev = version;
    hash = "sha256-aa2bRGn8Hn7gpEMUM7byh1qZVsqvJeMXomnwCj2Xu5o=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
  };
}
