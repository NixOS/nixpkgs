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
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "whirlpool-sixth-sense";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    tag = finalAttrs.version;
    hash = "sha256-D7rI4FEBXhx4czY/JTgjga1lW1WLSCV9d+5N2js2t3E=";
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

  meta = {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    changelog = "https://github.com/abmantis/whirlpool-sixth-sense/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
