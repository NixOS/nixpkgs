{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, dacite
, orjson
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zadnegoale";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ubBN4jvueNgReNbS+RXNDNHID0MF/rvQnb0+F4/DZaU=";
  };

  propagatedBuildInputs = [
    aiohttp
    dacite
    orjson
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zadnegoale"
  ];

  meta = with lib; {
    description = "Python wrapper for getting allergen concentration data from Żadnego Ale servers";
    homepage = "https://github.com/bieniu/zadnegoale";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
