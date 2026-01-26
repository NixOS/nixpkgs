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
}:

buildPythonPackage rec {
  pname = "victron-vrm";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KSoft-Si";
    repo = "vrm-client";
    tag = "v${version}";
    hash = "sha256-NxkMUwiFD8C7Nrtd7cjoFvdkbAOJkIIt+TPtkous8Nc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pydantic
    pytz
  ];

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
