{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "zinvolt";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-zinvolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4p+2zzBDuS6N6b+FhE6mWRFBzCzzkxApVlQai7sG/HM=";
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

  pythonImportsCheck = [ "zinvolt" ];

  meta = {
    description = "Asynchronous Python client for Zinvolt";
    homepage = "https://github.com/joostlek/python-zinvolt";
    changelog = "https://github.com/joostlek/python-zinvolt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
