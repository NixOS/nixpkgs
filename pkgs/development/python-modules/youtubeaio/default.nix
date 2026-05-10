{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  pydantic,
  yarl,
  aresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "youtubeaio";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-youtube";
    tag = "v${version}";
    hash = "sha256-GE06T3NSA2JdPSd2kS7rf3abI+b/zegS34n3Oxj2tnE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pydantic
    yarl
  ];

  pythonImportsCheck = [ "youtubeaio" ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/joostlek/python-youtube/releases/tag/${src.tag}";
    description = "Asynchronous Python client for the YouTube V3 API";
    homepage = "https://github.com/joostlek/python-youtube";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
