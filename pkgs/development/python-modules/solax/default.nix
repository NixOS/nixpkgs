{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools-scm,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "solax";
<<<<<<< HEAD
  version = "3.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-60FIDhd60zaWcwPnq7P7WxuXQc1MivWNTctj3TuZF3k=";
=======
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ht+UP/is9+galMiVz/pkwtre1BXfCTT39SpSz4Vctvs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    changelog = "https://github.com/squishykid/solax/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    changelog = "https://github.com/squishykid/solax/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
