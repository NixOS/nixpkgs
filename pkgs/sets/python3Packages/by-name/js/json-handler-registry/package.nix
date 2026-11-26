{
  lib,
  buildPythonPackage,
  dataclasses-json,
  fetchFromBitbucket,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-handler-registry";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "massultidev";
    repo = "json-handler-registry";
    tag = finalAttrs.version;
    hash = "sha256-oB2zsA6H1D27m87+mBKCDaN/kuxtc74RY29zSXovBKU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    dataclasses-json
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "json_handler_registry" ];

  meta = {
    description = "Registry for JSON handlers";
    homepage = "https://bitbucket.org/massultidev/json-handler-registry";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
