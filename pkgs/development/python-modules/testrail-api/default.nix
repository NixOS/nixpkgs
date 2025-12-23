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
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "testrail-api";
    tag = version;
    hash = "sha256-0RrNqSuimXXBEkjmnRQiIXUDy6z2y9wKneWqBTi5FHY=";
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
    changelog = "https://github.com/tolstislon/testrail-api/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
