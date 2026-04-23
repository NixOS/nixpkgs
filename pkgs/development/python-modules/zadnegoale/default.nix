{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  dacite,
  orjson,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zadnegoale";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "zadnegoale";
    tag = version;
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

  pythonImportsCheck = [ "zadnegoale" ];

  meta = {
    description = "Python wrapper for getting allergen concentration data from Żadnego Ale servers";
    homepage = "https://github.com/bieniu/zadnegoale";
    changelog = "https://github.com/bieniu/zadnegoale/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
