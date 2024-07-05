{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  lxml,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  quixote,
  setuptools,
}:

buildPythonPackage rec {
  pname = "twill";
  version = "3.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YlZKvOGxLWwGh+MqCXf8tfruxLK60H73k1VQhGOSTc8=";
  };

  pythonRelaxDeps = [ "lxml" ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
