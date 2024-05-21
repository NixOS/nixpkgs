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
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ij8xou8LXC4/BUTApIV6xSgb7ethwLyrHNJvBgxSBYM=";
  };

  propagatedBuildInputs = [
    aiohttp
    dacite
    orjson
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/bieniu/zadnegoale/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
