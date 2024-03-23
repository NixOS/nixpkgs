{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, setuptools-scm
, voluptuous
}:

buildPythonPackage rec {
  pname = "solax";
  version = "3.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PQ7qJCNfXGNF2RK6pHwf0U1DXgv2j2uQ64Nv/qh8f8s=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "solax"
  ];

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
