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
  version = "0.7.8";
  pname = "textstat";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textstat";
    repo = "textstat";
    tag = version;
    hash = "sha256-EEGTmZXTAZ4fsfZk/ictvjQ6lCAi5Ma/Ae83ziGDQXQ=";
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
