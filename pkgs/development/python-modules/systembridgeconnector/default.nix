{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  incremental,
  packaging,
  systembridgemodels,
  pytest-aiohttp,
  pytest-socket,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "systembridgeconnector";
  version = "4.1.6";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    tag = version;
    hash = "sha256-E04ETXfrh+1OY8WsNNJEeYlnqQcHWR3CX/E7SOd7/24=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail ">=" " #"

    substituteInPlace systembridgeconnector/_version.py \
      --replace-fail ", dev=0" ""
  '';

  build-system = [
    incremental
    setuptools
  ];

  dependencies = [
    aiohttp
    packaging
    systembridgemodels
  ];

  pythonImportsCheck = [ "systembridgeconnector" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-socket
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_get_data"
    "test_wait_for_response_timeout"
  ];

  pytestFlags = [ "--snapshot-warn-unused" ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
