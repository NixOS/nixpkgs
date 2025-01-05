{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "solax";
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eeALI7GvhRl8OQaSqv1I26rMaBTxF24w4QQzUcnV2ys=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    async-timeout
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "solax" ];

  disabledTests = [
    # Tests require network access
    "test_discovery"
    "test_smoke"
  ];

  meta = with lib; {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    changelog = "https://github.com/squishykid/solax/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
