{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  pydantic,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "youtubeaio";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-youtube";
    rev = "refs/tags/v${version}";
    hash = "sha256-utkf5t6yrf0f9QBIaDH6MxKduNZOsjfEWfQnuVyUoRM=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  pythonImportsCheck = [ "youtubeaio" ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/joostlek/python-youtube/releases/tag/v${version}";
    description = "Asynchronous Python client for the YouTube V3 API";
    homepage = "https://github.com/joostlek/python-youtube";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
