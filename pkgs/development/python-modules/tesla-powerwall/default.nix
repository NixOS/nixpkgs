{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
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

  src = fetchFromGitHub {
    owner = "jrester";
    repo = "tesla_powerwall";
    tag = "v${version}";
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

  disabledTests = [
    # yarl compat issue https://github.com/jrester/tesla_powerwall/issues/68
    "test_parse_endpoint"
  ];

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "tesla_powerwall" ];

  meta = {
    description = "API for Tesla Powerwall";
    homepage = "https://github.com/jrester/tesla_powerwall";
    changelog = "https://github.com/jrester/tesla_powerwall/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
