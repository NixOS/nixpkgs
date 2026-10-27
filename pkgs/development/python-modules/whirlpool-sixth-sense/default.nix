{
  lib,
  aioconsole,
  aiohttp,
  aiointercept,
  aioresponses,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pythonOlder,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "whirlpool-sixth-sense";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    tag = finalAttrs.version;
    hash = "sha256-s3chUYo3rMWLnDYioI3kPrd5GLERtnMihfWh6eqgI0Q=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aioconsole
    aiohttp
    async-timeout
    paho-mqtt
    websockets
  ];

  nativeCheckInputs = [
    aioresponses
    aiointercept
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "whirlpool" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    changelog = "https://github.com/abmantis/whirlpool-sixth-sense/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
