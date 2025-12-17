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
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-youtube";
    tag = "v${version}";
    hash = "sha256-2PqVFZ5816g8Ilc0Mhlm+Gzw/eOSaC1JYPY/t2yzxCU=";
  };

  postPatch = ''
    substituteInPlace tests/__snapshots__/test_video.ambr \
      --replace-fail "TzInfo(0)" "TzInfo(UTC)"
  '';

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
