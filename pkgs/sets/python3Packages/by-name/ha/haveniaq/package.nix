{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "haveniaq";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "krhtzoa";
    repo = "haveniaq-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cJyjXnWD9qC3q+Hu3JBrmAdtEOslP8+6YQBBMFunBBk=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "haveniaq" ];

  meta = {
    description = "Async Python client for HAVEN IAQ local HTTP APIs";
    homepage = "https://github.com/krhtzoa/haveniaq-python";
    changelog = "https://github.com/krhtzoa/haveniaq-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
