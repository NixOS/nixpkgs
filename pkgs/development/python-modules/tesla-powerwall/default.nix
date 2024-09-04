{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  aiohttp,
  urllib3,
  orjson,
  aresponses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tesla-powerwall";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrester";
    repo = "tesla_powerwall";
    rev = "refs/tags/v${version}";
    hash = "sha256-cAsJKFM0i0e7w2T4HP4a5ybJGuDvBAGCGmPEKFzNFAY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    urllib3
    orjson
  ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "tesla_powerwall" ];

  meta = with lib; {
    description = "API for Tesla Powerwall";
    homepage = "https://github.com/jrester/tesla_powerwall";
    changelog = "https://github.com/jrester/tesla_powerwall/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
