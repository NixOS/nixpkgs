{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "zinvolt";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-zinvolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BFdvRQMVXeTkh0TidvwH8vu/rpdE+xWDsKSx6Pc+c+4=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aiointercept
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
