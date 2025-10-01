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
  version = "4.1.11";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    tag = version;
    hash = "sha256-C7J2G5Go5y1iXjEPS6uIB38C8SAkEWfn9K1cnUhi+8k=";
  };

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

  disabledTestPaths = [
    # https://github.com/timmo001/system-bridge-connector/commit/18da51bd67e6d2a83d08f0c19c904326863264ca
    "tests/test__version.py"
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
