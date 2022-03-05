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
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e66db0c5d4ec840b047e574f0325ea01862d1f5563a844510541b35faa55f392";
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
