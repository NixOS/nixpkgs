{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "testrail-api";
  version = "1.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "testrail-api";
    rev = "refs/tags/${version}";
    hash = "sha256-VH63shGCBOkbHcUFL4M/QvuVrS+y2JiM1YYBJgZ6r/w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "testrail_api" ];

  meta = {
    description = "Python wrapper of the TestRail API";
    homepage = "https://github.com/tolstislon/testrail-api";
    changelog = "https://github.com/tolstislon/testrail-api/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
