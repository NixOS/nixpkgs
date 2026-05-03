{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  mashumaro,
  orjson,
  yarl,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "trmnl";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-trmnl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gpyhp+d27/IxDOTFxcN9ltYbOJOg9scf17qVb/ArBw0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "trmnl" ];

  meta = {
    description = "Asynchronous Python client for TRMNL";
    homepage = "https://github.com/joostlek/python-trmnl";
    changelog = "https://github.com/joostlek/python-trmnl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
