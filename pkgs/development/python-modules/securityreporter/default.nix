{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "securityreporter";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dongit-org";
    repo = "python-reporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ddq1qjaQemawK+u3ArlsChrkzRbcuaj5LrswyTGwTrg=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    docker
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "reporter" ];

  disabledTestPaths = [
    # Test require a running Docker instance
    "tests/functional/"
  ];

  meta = with lib; {
    description = "A Python wrapper for the Reporter API";
    homepage = "https://github.com/dongit-org/python-reporter";
    changelog = "https://github.com/dongit-org/python-reporter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
