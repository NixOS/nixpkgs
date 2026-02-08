{
  lib,
  aioconsole,
  aiohttp,
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

buildPythonPackage rec {
  pname = "whirlpool-sixth-sense";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    tag = version;
    hash = "sha256-n+PZHk64F7azgqeio8F5b/AheaZMh5TjvUXTgTc7q4A=";
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
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "whirlpool" ];

  meta = {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    changelog = "https://github.com/abmantis/whirlpool-sixth-sense/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
