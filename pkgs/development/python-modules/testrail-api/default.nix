{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "testrail-api";
  version = "1.13.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "testrail-api";
    tag = version;
    hash = "sha256-xCarEmJM+liyh8T8qG8sqSLXMnFN49yZapbktIElSF0=";
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
