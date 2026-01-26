{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  httpx,
  lxml,
  pyparsing,
  pytestCheckHook,
  quixote,
  setuptools,
}:

buildPythonPackage rec {
  pname = "twill";
  version = "3.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/ZT5ntn7YMafrD9/rWaOvROKo+CGFKSldG9jjH/eR0Q=";
  };

  pythonRelaxDeps = [ "lxml" ];

  build-system = [ setuptools ];

  dependencies = [
    httpx
    lxml
    pyparsing
  ];

  nativeCheckInputs = [
    flask
    pytestCheckHook
    quixote
  ];

  disabledTestPaths = [
    # pytidylib is abandoned
    "tests/test_tidy.py"
  ];

  pythonImportsCheck = [ "twill" ];

  meta = {
    description = "Simple scripting language for Web browsing";
    homepage = "https://twill-tools.github.io/twill/";
    changelog = "https://github.com/twill-tools/twill/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
