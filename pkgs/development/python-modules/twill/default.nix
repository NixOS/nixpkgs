{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  lxml,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  quixote,
  setuptools,
}:

buildPythonPackage rec {
  pname = "twill";
  version = "3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IprmAuqwzMwB6ryw0GsdRfeFK6ABP4nBM6VdlfgGNoQ=";
  };

  pythonRelaxDeps = [ "lxml" ];

  build-system = [ setuptools ];

  dependencies = [
    httpx
    lxml
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
    quixote
  ];

  disabledTestPaths = [
    # pytidylib is abandoned
    "tests/test_tidy.py"
  ];

  pythonImportsCheck = [ "twill" ];

  meta = with lib; {
    description = "Simple scripting language for Web browsing";
    homepage = "https://twill-tools.github.io/twill/";
    changelog = "https://github.com/twill-tools/twill/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
