{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  incremental,
  packaging,
  pyprojectVersionPatchHook,
  pytest-aiohttp,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "systembridgeconnector";
  version = "5.20.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge";
    tag = version;
    hash = "sha256-Cm03PEl99dMhljOvvb7ziXMrsaqsNMVKgvtOUVBBf/E=";
  };

  sourceRoot = "${src.name}/connector/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail setuptools==84.1.0 setuptools
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    incremental
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
  ];

  dependencies = [
    aiohttp
    packaging
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
    changelog = "https://github.com/timmo001/system-bridge/releases/tag/${src.tag}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge/tree/dev/connector/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
