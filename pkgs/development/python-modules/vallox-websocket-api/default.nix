{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  construct,
  websockets,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    tag = version;
    hash = "sha256-i4KUXvDz6FCdQguZtpNybyIPC/gn+O3SAYWh2CIbAeI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    construct
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vallox_websocket_api" ];

  meta = {
    changelog = "https://github.com/yozik04/vallox_websocket_api/releases/tag/${src.tag}";
    description = "Async API for Vallox ventilation units";
    homepage = "https://github.com/yozik04/vallox_websocket_api";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
