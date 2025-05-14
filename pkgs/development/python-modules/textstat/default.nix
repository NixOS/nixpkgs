{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyphen,
  pytestCheckHook,
  pytest,
}:
buildPythonPackage rec {
  version = "0.7.4";
  pname = "textstat";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textstat";
    repo = "textstat";
    rev = version;
    hash = "sha256-UOCWsIdoVGxmkro4kNBYNMYhA3kktngRDxKjo6o+GXY=";
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
  ];

  pythonImportsCheck = [
    "textstat"
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  meta = {
    description = "Python package to calculate readability statistics of a text object";
    homepage = "https://textstat.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
