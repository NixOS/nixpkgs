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

buildPythonPackage (finalAttrs: {
  pname = "twill";
  version = "3.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wG1py+No7OQ8dfM93EOalot6gdB9bN4DsLinfq74dcs=";
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
    changelog = "https://github.com/twill-tools/twill/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
})
