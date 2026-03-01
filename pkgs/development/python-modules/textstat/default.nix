{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmudict,
  setuptools,
  pyphen,
  pytestCheckHook,
  pytest,
}:
buildPythonPackage rec {
  version = "0.7.12";
  pname = "textstat";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textstat";
    repo = "textstat";
    tag = version;
    hash = "sha256-HOYeWpyWPLUEwnj21WfMNmIg9x+jQUtY1o+Sl5zJRq4=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest
  ];

  dependencies = [
    setuptools
    pyphen
    cmudict
  ];

  pythonImportsCheck = [
    "textstat"
  ];

  enabledTestPaths = [
    "tests/"
  ];

  meta = {
    description = "Python package to calculate readability statistics of a text object";
    homepage = "https://textstat.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
