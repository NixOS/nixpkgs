{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  aiohttp,
  aiointercept,
  mashumaro,
  orjson,
  yarl,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "trmnl";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-trmnl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jWGEloiWnDIr5SJ7cAoux+fOdptTVXuH4/WeypBaYcg=";
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

  pythonImportsCheck = [ "trmnl" ];

  meta = {
    description = "Asynchronous Python client for TRMNL";
    homepage = "https://github.com/joostlek/python-trmnl";
    changelog = "https://github.com/joostlek/python-trmnl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
