{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-cov
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, setuptools-scm
, voluptuous
}:

buildPythonPackage rec {
  pname = "solax";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kseU6JK00GTPyqdWku2ceT5/mChMVVPgEEib3BmjI/g=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "solax"
  ];

  meta = with lib; {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
