{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-cov
, pytest-httpserver
, pytestCheckHook
, setuptools-scm
, voluptuous
}:

buildPythonPackage rec {
  pname = "solax";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3WhJBBnIl6C0AdEsmSX3ZEVDThzCBguS4UUri80ifGg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ aiohttp voluptuous ];

  checkInputs = [
    pytest-asyncio
    pytest-cov
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "solax" ];

  meta = with lib; {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
