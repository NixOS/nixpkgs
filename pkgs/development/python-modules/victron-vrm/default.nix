{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pytz,
  victron-mqtt,
}:

buildPythonPackage rec {
  pname = "victron-vrm";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KSoft-Si";
    repo = "vrm-client";
    tag = "v${version}";
    hash = "sha256-In4yL5e6DZkP/8JeM1FhoMuhsqQ6uZE3fFLyfnLzgZQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pydantic
    pytz
    victron-mqtt
  ];

  pythonRelaxDeps = [ "victron-mqtt" ];

  pythonImportsCheck = [ "victron_vrm" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # tests connect to vrmapi.victronenergy.com
  doCheck = false;

  meta = {
    changelog = "https://github.com/KSoft-Si/vrm-client/releases/tag/${src.tag}";
    description = "Async Python client for the Victron Energy VRM API";
    homepage = "https://github.com/KSoft-Si/vrm-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
