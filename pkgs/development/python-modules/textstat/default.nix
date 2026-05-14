{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nltk,
  setuptools,
  pyphen,
  pytestCheckHook,
  pytest,
}:
buildPythonPackage (finalAttrs: {
  version = "0.7.13";
  pname = "textstat";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textstat";
    repo = "textstat";
    tag = finalAttrs.version;
    hash = "sha256-VMWwhwyGMFaKNLHoDG3gw1/jzSYCDBH3Yq4pE4JZTTo=";
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
    nltk
  ];

  pythonImportsCheck = [
    "textstat"
  ];

  enabledTestPaths = [
    "tests/"
  ];

  env.NLTK_DATA = nltk.data.cmudict;

  meta = {
    description = "Python package to calculate readability statistics of a text object";
    homepage = "https://textstat.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
