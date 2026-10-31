{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sunsynk-api-client";
  version = "1.4.0";
  pyproject = true;
  disabled = pythonOlder "3.13";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "jamesridgway";
    repo = "sunsynk-api-client";
    tag = finalAttrs.version;
    hash = "sha256-6TL0UPcfPI6B1QkkO5IP+2M4CbsyUnhflck10BPNRiU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sunsynk.client" ];

  meta = {
    description = "API client for interacting with SunSynk APIs";
    homepage = "https://github.com/jamesridgway/sunsynk-api-client";
    changelog = "https://github.com/jamesridgway/sunsynk-api-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
