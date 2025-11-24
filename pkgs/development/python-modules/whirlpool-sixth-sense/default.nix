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
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    tag = version;
    hash = "sha256-SXa5Ccnng1McWgSWy85xCEr7odtBSJtJhjZoC/JfI/A=";
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

  meta = with lib; {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    changelog = "https://github.com/abmantis/whirlpool-sixth-sense/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
