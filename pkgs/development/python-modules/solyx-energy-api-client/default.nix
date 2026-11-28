{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "solyx-energy-api-client";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "openremote";
    repo = "solyx-homeassistant-integration";
    rev = "ea4377b67e6c953a0c01a978579fe857a8f60c0b";
    hash = "sha256-/PqhZNInow8vEbwcAJP3UOwqsIbwjjKetbOivh2mFeg=";
  };

  sourceRoot = "${finalAttrs.src.name}/libraries/api";

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "../../tests/api" ];

  pythonImportsCheck = [ "solyx_energy_api" ];

  meta = {
    description = "Async API client for Solyx Energy devices";
    homepage = "https://github.com/openremote/solyx-homeassistant-integration";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
