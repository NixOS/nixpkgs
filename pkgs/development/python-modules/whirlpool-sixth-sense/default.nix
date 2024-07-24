{
  lib,
  aioconsole,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "whirlpool-sixth-sense";
  version = "0.18.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "whirlpool-sixth-sense";
    rev = "refs/tags/${version}";
    hash = "sha256-aDvUV83o/yKx15kenDGng5xh3LECLVlLWJlVe/y+1Co=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aioconsole
    aiohttp
    async-timeout
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  # https://github.com/abmantis/whirlpool-sixth-sense/issues/15
  doCheck = false;

  pythonImportsCheck = [ "whirlpool" ];

  meta = with lib; {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
