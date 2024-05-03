{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, aiohttp
, incremental
, systembridgemodels
, pytest-aiohttp
, pytest-socket
, pytestCheckHook
, syrupy
}:

buildPythonPackage rec {
  pname = "systembridgeconnector";
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    rev = "refs/tags/${version}";
    hash = "sha256-Cdf5FRCzq3S+zsLx2CQni4Yf5zS35THtVgWMq6j91HQ=";
  };

  postPatch = ''
    substituteInPlace systembridgeconnector/_version.py \
      --replace-fail ", dev=0" ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    incremental
    systembridgemodels
  ];

  pythonImportsCheck = [ "systembridgeconnector" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-socket
    pytestCheckHook
    syrupy
  ];

  disabledTestPaths = [
    # TypeError: System.__init__() missing 1 required positional argument: 'run_mode'
    "tests/test_version.py"
  ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
