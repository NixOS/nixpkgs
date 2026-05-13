{
  lib,
  buildPythonPackage,
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
  version = "5.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    tag = version;
    hash = "sha256-gkZRvS0abfXFEz2oRuaGJRmhFoxe92F3czNkahNdTm8=";
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
    "test_execute_command"
    "test_get_commands"
    "test_get_data"
    "test_get_directories"
    "test_get_file"
    "test_sensors"
    "test_system"
    "test_update"
    "test_wait_for_response_timeout"
  ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
