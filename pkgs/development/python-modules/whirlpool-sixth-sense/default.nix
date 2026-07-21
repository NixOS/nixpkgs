{
  lib,
  aioconsole,
  aiohttp,
  aiointercept,
  aioresponses,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "whirlpool-sixth-sense";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    tag = finalAttrs.version;
    hash = "sha256-zqdgZw3PAZ0tONwkdR5jgZNvSc8IiGj0Zr855ewsPpI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aioconsole
    aiohttp
    async-timeout
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
